Framework = nil
Skillbar = {}
Skillbar.Data = {}

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
    TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)  
 end)
end)

Skillbar.Data = {
    Active = false,
    Data = {},
}
successCb = nil
failCb = nil

-- NUI Callback's

RegisterNUICallback('Check', function(data, cb)
    if successCb ~= nil then
        Skillbar.Data.Active = false
        if data.success then
            successCb()
        else
            failCb()
            SendNUIMessage({
                action = "stop"
            })
        end
    end
end)

Skillbar.Start = function(data, success, fail)
    if not Skillbar.Data.Active then
        Skillbar.Data.Active = true
        if success ~= nil then
            successCb = success
        end
        if fail ~= nil then
            failCb = fail
        end
        Skillbar.Data.Data = data
        SendNUIMessage({
            action = "start",
            duration = data.duration,
            pos = data.pos,
            width = data.width,
        })
    else
        Framework.Functions.Notify('Je bent al met iets bezig..', 'error')
    end
end

Skillbar.Repeat = function(data)
    Skillbar.Data.Active = true
    Skillbar.Data.Data = data
    Citizen.CreateThread(function()
        Wait(500)
        SendNUIMessage({
            action = "start",
            duration = Skillbar.Data.Data.duration,
            pos = Skillbar.Data.Data.pos,
            width = Skillbar.Data.Data.width,
        }) 
    end)
end

Citizen.CreateThread(function()
    while true do
        if Skillbar.Data.Active then
            if IsControlJustPressed(0, Keys["E"]) then
                SendNUIMessage({
                    action = "check",
                    data = Skillbar.Data.Data,
                })
            end
        end
        Citizen.Wait(1)
    end
end)

function GetSkillbarObject()
    return Skillbar
end