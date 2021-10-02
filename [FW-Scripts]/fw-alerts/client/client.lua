local Framework = nil
local LoggedIn = false
local MouseActive = false
local AlertActive = false

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
	 Citizen.Wait(250)
     LoggedIn = true
 end)
end)

-- Code

RegisterNetEvent('fw-alerts:client:send:alert')
AddEventHandler('fw-alerts:client:send:alert', function(data, forBoth)
    if forBoth then
        if (Framework.Functions.GetPlayerData().job.name == "police" or Framework.Functions.GetPlayerData().job.name == "ambulance") and Framework.Functions.GetPlayerData().job.onduty then
            data.callSign = data.callSign ~= nil and data.callSign or '69-69'
            data.alertId = math.random(11111, 99999)
            SendNUIMessage({
                action = "add",
                data = data,
            })
            if data.priority == 1 then
                TriggerServerEvent("fw-sound:server:play:source", "alert-high-prio", 0.2)
            elseif data.priority == 2 then
                PlaySoundFrontend(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
                Citizen.Wait(100)
                PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                Citizen.Wait(100)
                PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
                Citizen.Wait(100)
                PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            elseif data.priority == 3 then
                TriggerServerEvent("fw-sound:server:play:source", "alert-panic-button", 0.5)
            else
                PlaySoundFrontend(-1, "Lose_1st", "GTAO_FM_Events_Soundset", true)
            end
        end
    else
        if (Framework.Functions.GetPlayerData().job.name == "police" and Framework.Functions.GetPlayerData().job.onduty) then
            data.callSign = data.callSign ~= nil and data.callSign or '69-69'
            data.alertId = math.random(11111, 99999)
            SendNUIMessage({
                action = "add",
                data = data,
            })
            if data.priority == 1 then
                TriggerServerEvent("fw-sound:server:play:source", "alert-high-prio", 0.2)
            elseif data.priority == 2 then
                PlaySoundFrontend(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
                Citizen.Wait(100)
                PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                Citizen.Wait(100)
                PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
                Citizen.Wait(100)
                PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
            elseif data.priority == 3 then
                TriggerServerEvent("fw-sound:server:play:source", "alert-panic-button", 0.5)
            else
                PlaySoundFrontend(-1, "Lose_1st", "GTAO_FM_Events_Soundset", true)
            end
        end 
    end
    AlertActive = true
    SetTimeout(data.timeOut, function()
        AlertActive = false
    end)
end)

RegisterNetEvent('fw-alerts:client:open:previous:alert')
AddEventHandler('fw-alerts:client:open:previous:alert', function(JobName)
    MouseActive, AlertActive = false, false
    if JobName == 'police' then
        SendNUIMessage({action = 'History'})
        SetNuiFocus(true, true)
    else
        SendNUIMessage({action = 'History'})
        SetNuiFocus(true, true)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(6)
        if AlertActive then
            if IsControlJustPressed(0, Keys["LEFTALT"]) then
             if (Framework.Functions.GetPlayerData().job.name == "police" or Framework.Functions.GetPlayerData().job.name == "ambulance") and Framework.Functions.GetPlayerData().job.onduty then
                SetNuiFocus(true, true)
                SetNuiFocusKeepInput(true, true)
                SetCursorLocation(0.965, 0.12)
                MouseActive = true
            end
        end
    end
        if MouseActive then
            if IsControlJustReleased(0, Keys["LEFTALT"]) then
             if (Framework.Functions.GetPlayerData().job.name == "police" or Framework.Functions.GetPlayerData().job.name == "ambulance") and Framework.Functions.GetPlayerData().job.onduty then
                SetNuiFocus(false, false)
                DisablePlayerFiring(PlayerPedId(), false)
                SetNuiFocusKeepInput(false, false)
                MouseActive = false
            end
        end
    end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if MouseActive then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 289, true)
            DisableControlAction(0, 288, true)
            DisableControlAction(0, 346, true)
            DisablePlayerFiring(PlayerPedId(), true)
        else
            Citizen.Wait(450)
        end
    end
end)

RegisterNUICallback('CloseNui', function(data, cb)
    SetNuiFocus(false, false)
    DisablePlayerFiring(PlayerPedId(), false)
end)

RegisterNUICallback('SetWaypoint', function(data)
    local coords = data.coords
    SetNewWaypoint(coords.x, coords.y)
    Framework.Functions.Notify('GPS ingesteld!', 'success')
end)