local LastRobbedNpc = nil
local InSideTrap = false
local CanEnterTraphouse = false
local HouseData, OffSets = nil, nil
local Selling = false
local LoggedIn = false

Framework = nil

RegisterNetEvent("Framework:Client:OnPlayerLoaded")
AddEventHandler("Framework:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(1000, function()
        TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
        Citizen.Wait(250)
        Framework.Functions.TriggerCallback("fw-traphouse:server:get:config", function(config)
            Config = config
        end)
        LoggedIn = true
    end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
         if LoggedIn then
            NearTrapHouse = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = GetDistanceBetweenCoords(PlayerCoords, Config.TrapHouse["Coords"]['Enter']["X"], Config.TrapHouse["Coords"]['Enter']["Y"], Config.TrapHouse["Coords"]['Enter']["Z"], true)
            if Distance <= 2.0 then
             NearTrapHouse = true
             CanEnterTraphouse = true
             DrawMarker(2, Config.TrapHouse["Coords"]['Enter']["X"], Config.TrapHouse["Coords"]['Enter']["Y"], Config.TrapHouse["Coords"]['Enter']["Z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 242, 148, 41, 255, false, false, false, 1, false, false, false)
            elseif Distance <= 150.0 then
                CanEnterTraphouse = false
                NearTrapHouse = true
                local Robbing = false
                local AimingWeapon, TargetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
                if TargetPed ~= -1 and not IsPedAPlayer(TargetPed) then
                    if IsPedArmed(GetPlayerPed(-1), 6) then
                      if AimingWeapon then
                          local NpcCoords = GetEntityCoords(TargetPed)
                          local NpcDistance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, NpcCoords.x, NpcCoords.y, NpcCoords.z, true)
                          if NpcDistance < 2 then
                              if LastRobbedNpc ~= TargetPed then
                              if not Robbing then
                                  if not IsEntityDead(TargetPed) then
                                       Robbing = true
                                       if IsPedInAnyVehicle(TargetPed) then
                                           TaskLeaveVehicle(TargetPed, GetVehiclePedIsIn(TargetPed), 1)
                                       end
                                       Citizen.Wait(500)
                                       SetEveryoneIgnorePlayer(PlayerId(), true)
                                       TaskStandStill(TargetPed, 5 * 1000)
                                       FreezeEntityPosition(TargetPed, true)
                                       SetBlockingOfNonTemporaryEvents(TargetPed, true)
                                       exports['fw-assets']:RequestAnimationDict("random@mugging3")
                                       TaskPlayAnim(TargetPed, 'random@mugging3', 'handsup_standing_base', 2.0, -2, 15.0, 1, 0, 0, 0, 0)
                                       for i = 1, 5 / 2, 1 do
                                           PlayAmbientSpeech1(TargetPed, "GUN_BEG", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
                                           Citizen.Wait(2000)
                                       end
                                       Citizen.Wait(5000)
                                       FreezeEntityPosition(TargetPed, false)
                                       SetEveryoneIgnorePlayer(PlayerId(), false)
                                       SetBlockingOfNonTemporaryEvents(TargetPed, false)
                                       ClearPedTasks(TargetPed)
                                       AddShockingEventAtPosition(99, GetEntityCoords(TargetPed), 0.5)
                                       TriggerServerEvent('fw-traphouse:server:rob:npc')
                                       LastRobbedNpc = TargetPed
                                       Citizen.SetTimeout(30000, function()
                                         Robbing = false
                                       end)
                                      end
                                  end
                              end
                          end
                        else
                            Citizen.Wait(150)
                      end
                    else
                        Citizen.Wait(150)
                    end
                end
            end
            if not NearTrapHouse then
                Citizen.Wait(1500)
                CanEnterTraphouse = false
             end
         end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
         if LoggedIn then
            if InSideTrap then
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                if OffSets ~= nil then
                if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.TrapHouse["Coords"]['Enter']["X"] - OffSets.exit.x, Config.TrapHouse["Coords"]['Enter']["Y"] -  OffSets.exit.y, Config.TrapHouse["Coords"]['Enter']["Z"] -  OffSets.exit.z, true) < 3.0) then
                    DrawMarker(2, Config.TrapHouse["Coords"]['Enter']["X"] - OffSets.exit.x, Config.TrapHouse["Coords"]['Enter']["Y"] -  OffSets.exit.y, Config.TrapHouse["Coords"]['Enter']["Z"] -  OffSets.exit.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                    DrawText3D(Config.TrapHouse["Coords"]['Enter']["X"] - OffSets.exit.x, Config.TrapHouse["Coords"]['Enter']["Y"] -  OffSets.exit.y, Config.TrapHouse["Coords"]['Enter']["Z"] -  OffSets.exit.z, '~g~E~s~ - Naar Buiten')
                    if IsControlJustReleased(0, 38) then
                        LeaveTrapHouse()
                    end
                  end
                  if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.TrapHouse["Coords"]['Interact']["X"], Config.TrapHouse["Coords"]['Interact']["Y"], Config.TrapHouse["Coords"]['Interact']["Z"], true) < 3.0) then
                    if Config.IsSelling then
                        DrawMarker(2, Config.TrapHouse["Coords"]['Interact']["X"], Config.TrapHouse["Coords"]['Interact']["Y"], Config.TrapHouse["Coords"]['Interact']["Z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 222, 172, 44, 255, false, false, false, 1, false, false, false)
                        DrawText3D(Config.TrapHouse["Coords"]['Interact']["X"], Config.TrapHouse["Coords"]['Interact']["Y"], Config.TrapHouse["Coords"]['Interact']["Z"] + 0.15, '~o~Bezig met verkopen..')
                    else
                        DrawMarker(2, Config.TrapHouse["Coords"]['Interact']["X"], Config.TrapHouse["Coords"]['Interact']["Y"], Config.TrapHouse["Coords"]['Interact']["Z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                        DrawText3D(Config.TrapHouse["Coords"]['Interact']["X"], Config.TrapHouse["Coords"]['Interact']["Y"], Config.TrapHouse["Coords"]['Interact']["Z"] + 0.15, '~g~E~s~ - Doe Iets')
                        if IsControlJustReleased(0, 38) then
                            TryToSell()
                        end
                    end
                  end

                end
            else
                Citizen.Wait(1500)
            end
         end
    end
end)

RegisterNetEvent('fw-traphouse:client:set:selling:state')
AddEventHandler('fw-traphouse:client:set:selling:state', function(bool)
    Config.IsSelling = bool
end)

RegisterNetEvent('fw-traphouse:client:enter')
AddEventHandler('fw-traphouse:client:enter', function()
    Citizen.SetTimeout(450, function()
        Framework.Functions.TriggerCallback("fw-traphouse:server:is:current:owner", function(IsOwner)
            if IsOwner then
             EnterTrapHouse()
            else
             SetNuiFocus(true, true)
             SendNUIMessage({action = "open"})
            end
        end)
    end)
end)

RegisterNUICallback('PinpadClose', function(data)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ErrorMessage', function(data)
    Framework.Functions.Notify(data.message, 'error')
end)

RegisterNUICallback('EnterPincode', function(data)
  Framework.Functions.TriggerCallback('fw-traphouse:server:pin:code', function(Code)
      if tonumber(data.pin) ~= nil then
          if tonumber(data.pin) == Code then
            EnterTrapHouse()
            TriggerServerEvent('fw-traphouse:set:owner')
          else
            print('Dit is hem niet nerd')
            PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
          end
      end
  end, CurrentSafe)  
end)

RegisterNUICallback('Click', function(data)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('ClickFail', function(data)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

function EnterTrapHouse()
  local TrapHouse = {}
  local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
  local CoordsTable = {x = Config.TrapHouse["Coords"]['Enter']["X"], y = Config.TrapHouse["Coords"]['Enter']["Y"], z = Config.TrapHouse["Coords"]['Enter']["Z"] - Config.TrapHouse["Coords"]['Enter']["Z-OffSet"]}
  InSideTrap = true
  TriggerEvent("fw-sound:client:play", "house-door-open", 0.1)
  OpenDoorAnim()
  Citizen.Wait(350)
  TrapHouse = exports['fw-interiors']:TrapHouse(CoordsTable)
  TriggerEvent('fw-weathersync:client:DisableSync')
  HouseData, OffSets = TrapHouse[1], TrapHouse[2]
end

function LeaveTrapHouse()
  TriggerEvent("fw-sound:client:play", "house-door-open", 0.1)
  OpenDoorAnim()
  DoScreenFadeOut(500)
  while not IsScreenFadedOut() do
      Citizen.Wait(10)
  end
  exports['fw-interiors']:DespawnInterior(HouseData, function()
    SetEntityCoords(GetPlayerPed(-1), Config.TrapHouse["Coords"]['Enter']["X"], Config.TrapHouse["Coords"]['Enter']["Y"], Config.TrapHouse["Coords"]['Enter']["Z"])
    TriggerEvent('fw-weathersync:client:EnableSync')
    DoScreenFadeIn(1000)
    HouseData, OffSets = nil, nil
    InSideTrap = false
    TriggerEvent("fw-sound:client:play", "house-door-close", 0.1)
  end)
end

function TryToSell()
    Framework.Functions.TriggerCallback("fw-traphouse:server:has:sell:item", function(HasSellItem)
        if HasSellItem then
            TriggerServerEvent('fw-traphouse:server:set:selling:state', true)
            Citizen.SetTimeout(math.random(90000, 120000), function()
                TriggerServerEvent('fw-traphouse:server:sell:item')
                TriggerServerEvent('fw-traphouse:server:set:selling:state', false)
            end)
        else
            Framework.Functions.Notify('Je hebt geen items om te verkopen..', 'error')
        end
    end)
end

function OpenDoorAnim()
  exports['fw-assets']:RequestAnimationDict('anim@heists@keycard@')
  TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
  Citizen.Wait(400)
  ClearPedTasks(GetPlayerPed(-1))
end

function DrawText3D(x, y, z, text)
 SetTextScale(0.35, 0.35)
 SetTextFont(4)
 SetTextProportional(1)
 SetTextColour(255, 255, 255, 215)
 SetTextEntry("STRING")
 SetTextCentre(true)
 AddTextComponentString(text)
 SetDrawOrigin(x,y,z, 0)
 DrawText(0.0, 0.0)
 ClearDrawOrigin()
end

function CanPlayerEnterTraphouse()
    return CanEnterTraphouse
end