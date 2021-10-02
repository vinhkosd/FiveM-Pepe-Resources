
local ShowedNeededItem = false
local NearExit = false
local NearLab = false

InsideLab = false
CurrentLab = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearLab = false
            for k,v in pairs(Config.Labs) do
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['Enter']['X'], v['Coords']['Enter']['Y'], v['Coords']['Enter']['Z'], true)
                if Distance < 2.0 then
                    NearLab = true
                    CurrentLab = k
                    local ItemsNeeded = {[1] = {name = Framework.Shared.Items[v['KeyName']]["name"], image = Framework.Shared.Items[v['KeyName']]["image"]}}
                    if not ShowedNeededItem then
                        ShowedNeededItem = true
                        TriggerEvent('fw-inventory:client:requiredItems', ItemsNeeded, true)
                    end
                end
            end
            if not NearLab then
                if ShowedNeededItem then
                    ShowedNeededItem = false
                    TriggerEvent('fw-inventory:client:requiredItems', ItemsNeeded, false)
                end
                Citizen.Wait(1000)
                if not InsideLab then
                    CurrentLab = nil
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearExit = false
            if InsideLab then
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Labs[CurrentLab]['Coords']['Exit']['X'], Config.Labs[CurrentLab]['Coords']['Exit']['Y'], Config.Labs[CurrentLab]['Coords']['Exit']['Z'], true)
                if Distance < 2.0 then
                    NearExit = true
                    DrawText3D(Config.Labs[CurrentLab]['Coords']['Exit']['X'], Config.Labs[CurrentLab]['Coords']['Exit']['Y'], Config.Labs[CurrentLab]['Coords']['Exit']['Z'] + 0.1, '~g~E~s~ - Verlaten')
                    DrawMarker(2, Config.Labs[CurrentLab]['Coords']['Exit']['X'], Config.Labs[CurrentLab]['Coords']['Exit']['Y'], Config.Labs[CurrentLab]['Coords']['Exit']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                    if IsControlJustReleased(0, 38) then
                        ExitCurrentLab()
                    end
                end
                if not NearExit then
                    Citizen.Wait(1500)
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
end)

-- // Functions \\ --

RegisterNetEvent('fw-illegal:client:use:key')
AddEventHandler('fw-illegal:client:use:key', function(KeyName)
    if not InsideLab then
        if CurrentLab ~= nil then
            if KeyName == Config.Labs[CurrentLab]['KeyName'] then
                EnterCurrentLab()
            else
                Framework.Functions.Notify('Dit is niet de juiste sleutel..', 'error')
            end
        end
    end
end)

RegisterNetEvent('fw-illegal:client:sync:inventory')
AddEventHandler('fw-illegal:client:sync:inventory', function(LabId, data)
    Config.Labs[LabId]['Inventory'] = data
end)

function EnterCurrentLab()
 InsideLab = true
 TriggerEvent("fw-sound:client:play", "house-door-open", 0.1)
 OpenDoorAnim()
 Citizen.Wait(350)
 DoScreenFadeOut(500)
 while not IsScreenFadedOut() do
     Citizen.Wait(10)
 end
 Citizen.Wait(100)
 SetEntityCoords(GetPlayerPed(-1), Config.Labs[CurrentLab]['Coords']['Exit']['X'], Config.Labs[CurrentLab]['Coords']['Exit']['Y'], Config.Labs[CurrentLab]['Coords']['Exit']['Z'])
 Citizen.Wait(150)
 DoScreenFadeIn(500)
end

function ExitCurrentLab()
 TriggerEvent("fw-sound:client:play", "house-door-open", 0.1)
 OpenDoorAnim()
 Citizen.Wait(350)
 DoScreenFadeOut(500)
 while not IsScreenFadedOut() do
     Citizen.Wait(10)
 end
 Citizen.Wait(100)
 SetEntityCoords(GetPlayerPed(-1), Config.Labs[CurrentLab]['Coords']['Enter']['X'], Config.Labs[CurrentLab]['Coords']['Enter']['Y'], Config.Labs[CurrentLab]['Coords']['Enter']['Z'])
 Citizen.Wait(150)
 DoScreenFadeIn(500)
 InsideLab = false
end

function OpenDoorAnim()
 exports['fw-assets']:RequestAnimationDict('anim@heists@keycard@')
 TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
 Citizen.Wait(400)
 ClearPedTasks(GetPlayerPed(-1))
end
