local Framework = nil
local LoggedIn = false
local SillyWalk, InVehicle, Seatbelt = false, false, false
local Hunger, Thirst, Stress = 100, 100, 0

RegisterNetEvent("Framework:Client:OnPlayerLoaded")
AddEventHandler("Framework:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(750, function()
        TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
        Citizen.Wait(2000)
        Framework.Functions.GetPlayerData(function(PlayerData)
            if PlayerData.metadata['armor'] ~= 0 then
                SetPedArmour(GetPlayerPed(-1), tonumber(PlayerData.metadata['armor']))
            end
            if PlayerData.metadata['health'] ~= 0 then
                SetEntityHealth(GetPlayerPed(-1), tonumber(PlayerData.metadata["health"]))
            end
            Hunger, Thirst, Stress = PlayerData.metadata["hunger"], PlayerData.metadata["thirst"], PlayerData.metadata["stress"]
            Citizen.Wait(150)
            SendNUIMessage({action = 'Show'})
            SendNUIMessage({action = 'SetMoney', amount = PlayerData.money['cash']})
            LoggedIn = true
        end)
    end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    SendNUIMessage({action = 'Hide'})
    Hunger, Thirst, Stress = 100, 100, 0
    LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                DisplayRadar(true)
                if not InVehicle then
                  InVehicle = true
                  SendNUIMessage({
                      action = "OpenCarHud",
                  })
                end
            else
                DisplayRadar(false)
                if InVehicle then
                    InVehicle = false
                    SendNUIMessage({
                        action = "CloseCarHud",
                    })
                end
            end
            Citizen.Wait(250)
        else
            Citizen.Wait(450)
            DisplayRadar(false)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
     if LoggedIn then
        if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
            local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, GetEntityCoords(GetPlayerPed(-1)).x, GetEntityCoords(GetPlayerPed(-1)).y, GetEntityCoords(GetPlayerPed(-1)).z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
            local FirstStreetLabel = GetStreetNameFromHashKey(s1)
            SendNUIMessage({
              action = "UpdateHud",
              radio = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'radio:talking'),
              talking = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'voip:talking'),
              health = GetEntityHealth(PlayerPedId()),
              armor = GetPedArmour(PlayerPedId()),
              street = FirstStreetLabel,
              area = GetLabelText(GetNameOfZone(GetEntityCoords(GetPlayerPed(-1)))),
              thirst = math.floor(Thirst),
              hunger = math.floor(Hunger),
              stress = math.floor(Stress),
              hour = GetGameTime('Hours'),
              minute = GetGameTime('Minutes'),
            })  
            Citizen.Wait(700)
        else
            local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, GetEntityCoords(GetPlayerPed(-1)).x, GetEntityCoords(GetPlayerPed(-1)).y, GetEntityCoords(GetPlayerPed(-1)).z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
            local FirstStreetLabel = GetStreetNameFromHashKey(s1)
            local Speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1))) * 3.6
            local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)))
            SendNUIMessage({
              action = "UpdateHud",
              radio = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'radio:talking'),
              talking = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'voip:talking'),
              health = GetEntityHealth(PlayerPedId()),
              armor = GetPedArmour(PlayerPedId()),
              street = FirstStreetLabel,
              area = GetLabelText(GetNameOfZone(GetEntityCoords(GetPlayerPed(-1)))),
              thirst = math.floor(Thirst),
              hunger = math.floor(Hunger),
              stress = math.floor(Stress),
              speed = math.ceil(Speed),
              fuel = exports['fw-fuel']:GetFuelLevel(Plate),
              seatbelt = Seatbelt,
              hour = GetGameTime('Hours'),
              minute = GetGameTime('Minutes'),
            })  
            Citizen.Wait(50)
        end
        SetBlipAlpha(Citizen.InvokeNative(0x3F0CF9CB7E589B88), 0)
      end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if LoggedIn then
            if SillyWalk then
             RequestAnimSet("move_m@injured")
             while not HasAnimSetLoaded("move_m@injured") do Citizen.Wait(0) end
             SetPedMovementClipset(PlayerPedId(), "move_m@injured", true)
             Citizen.Wait(50)
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    local CurrentLevel = 1
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsControlJustReleased(0, 243) then
                CurrentLevel =  exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'voip:mode')
                if CurrentLevel == 1 then
                    SendNUIMessage({
                        action = "UpdateProximity",
                        prox = 2
                    })
                elseif CurrentLevel == 2 then
                    SendNUIMessage({
                        action = "UpdateProximity",
                        prox = 1
                    })
                elseif CurrentLevel == 3 then
                    SendNUIMessage({
                        action = "UpdateProximity",
                        prox = 3
                    })
                end
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if LoggedIn then
        local Wait = GetEffectInterval(Stress)
        if Stress >= 100 then
            local ShakeIntensity = GetShakeIntensity(Stress)
            local FallRepeat = math.random(2, 4)
            local RagdollTimeout = (FallRepeat * 1750)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            SetFlash(0, 0, 500, 3000, 500)
            if not IsPedRagdoll(GetPlayerPed(-1)) and IsPedOnFoot(GetPlayerPed(-1)) and not IsPedSwimming(GetPlayerPed(-1)) then
                SetPedToRagdollWithFall(PlayerPedId(), RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            end
            Citizen.Wait(500)
            for i = 1, FallRepeat, 1 do
                Citizen.Wait(750)
                DoScreenFadeOut(200)
                Citizen.Wait(1000)
                DoScreenFadeIn(200)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
                SetFlash(0, 0, 200, 750, 200)
            end
        elseif Stress >= Config.MinimumStress then
            local ShakeIntensity = GetShakeIntensity(Stress)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            SetFlash(0, 0, 500, 2500, 500)
        end
        Citizen.Wait(Wait)
    end
  end
end)
  
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if LoggedIn then
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
             local CurrentSpeed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6
               if CurrentSpeed >= 180 then
                   TriggerServerEvent('fw-hud:server:gain:stress', math.random(1,2))
                   Citizen.Wait(35000)
               end
            else
                Citizen.Wait(1500)
            end
        else
            Citizen.Wait(1500)
        end
    end
end)
  

-- // Events \\ --

RegisterNetEvent("fw-hud:client:update:needs")
AddEventHandler("fw-hud:client:update:needs", function(NewHunger, NewThirst)
    Hunger, Thirst = NewHunger, NewThirst
end)

RegisterNetEvent('fw-hud:client:update:stress')
AddEventHandler('fw-hud:client:update:stress', function(NewStress)
    Stress = NewStress
    Framework.Functions.Notify('Stress Opgedaan!')
end)

RegisterNetEvent('fw-hud:client:show:cash')
AddEventHandler('fw-hud:client:show:cash', function()
    SendNUIMessage({action = 'ShowCash'})
end)

RegisterNetEvent('fw-hud:client:show:current:players')
AddEventHandler('fw-hud:client:show:current:players', function()
    TriggerEvent('chatMessage', "SYSTEM", "cash", "Online Spelers: "..GetCurrentPlayers().."/64")
end)

RegisterNetEvent("fw-hud:client:money:change")
AddEventHandler("fw-hud:client:money:change", function(Amount, Type)
    Citizen.SetTimeout(150, function()
        if Type == 'Plus' then
            SendNUIMessage({action = 'ChangeMoney', type = 'Add', amount = Amount})
        else
            SendNUIMessage({action = 'ChangeMoney', type = 'Remove', amount = Amount})
        end
        SendNUIMessage({action = 'SetMoney', amount = Framework.Functions.GetPlayerData().money['cash']})
    end)
end)

-- // Functions \\ --

function SetSeatbelt(bool)
    Seatbelt = bool
end

function GetGameTime(Type)
    local Hours = GetClockHours()
    local Minutes = GetClockMinutes()
    if Type == 'Minutes' then
        if Minutes <= 9 then
            Minutes = "0" .. Minutes
        end
     return Minutes
    elseif Type == 'Hours' then
        if Hours <= 9 then
            Hours = "0" .. Hours
        end
     return Hours
    end
end

function GetShakeIntensity(stresslevel)
    local retval = 0.05
    for k, v in pairs(Config.Intensity["shake"]) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.intensity
            break
        end
    end
    return retval
end

function GetEffectInterval(stresslevel)
    local retval = 60000
    for k, v in pairs(Config.EffectInterval) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.timeout
            break
        end
    end
    return retval
end

function GetCurrentPlayers()
    local TotalPlayers = 0
    for _, player in ipairs(GetActivePlayers()) do
        TotalPlayers = TotalPlayers + 1
    end
    return TotalPlayers
end

RegisterNUICallback('SetBlood', function(data)
    if data.Bool then
        SillyWalk = true
        SetFlash(false, false, 450, 3000, 450)
        Citizen.Wait(350)
        SetTimecycleModifier('damage')
    else
        SillyWalk = false
        Framework.Functions.GetPlayerData(function(PlayerData)
            if not PlayerData.metadata['isdead'] then
                SetFlash(false, false, 450, 3000, 450)
                Citizen.Wait(350)
                ClearTimecycleModifier()
                ResetPedMovementClipset(PlayerPedId(), 0)
            end
        end)
    end
end)