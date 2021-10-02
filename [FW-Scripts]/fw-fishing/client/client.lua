Framework = nil

local IsSelling = false
local CurrentRadiusBlip = {}
local CurrentLocation = {
    ['Name'] = 'Fish1',
    ['Coords'] = {['X'] = 241.00, ['Y'] = 3993.00, ['Z'] = 30.40},
}
local CurrentBlip = {}
local LastLocation = nil  

local LoggedIn = false

RegisterNetEvent("Framework:Client:OnPlayerLoaded")
AddEventHandler("Framework:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(750, function()
        TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
        SetRandomLocation()
        Citizen.Wait(250)
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
          Citizen.Wait(1000 * 60 * 6)
          SetRandomLocation()
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(15000)
    while true do
        Citizen.Wait(4)
        if LoggedIn then
          NearFishArea = false
          local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
          local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, CurrentLocation['Coords']['X'], CurrentLocation['Coords']['Y'], CurrentLocation['Coords']['Z'], true)
          if Distance <= 75.0 then
              NearFishArea = true
              Config.CanFish = true
          end
          if not NearFishArea then
              Citizen.Wait(1500)
              Config.CanFish = false
          end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearArea = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Sell']['X'], Config.Locations['Sell']['Y'], Config.Locations['Sell']['Z'], true)
            if Distance <= 2.0 then
                NearArea = true
                if not IsSelling then
                  DrawText3D(Config.Locations['Sell']['X'], Config.Locations['Sell']['Y'], Config.Locations['Sell']['Z'], '~g~E~s~ - Water Goederen Verkopen')
                  if IsControlJustReleased(0, 38) then
                      IsSelling = true
                      Framework.Functions.Notify('Verkopen..', 'info')
                      TriggerServerEvent('fw-fishing:server:sell:items')
                      Citizen.SetTimeout(15000, function()
                          IsSelling = false
                      end)
                  end
                end
            end

            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Boat']['X'], Config.Locations['Boat']['Y'], Config.Locations['Boat']['Z'], true)
            if Distance <= 2.0 then
                NearArea = true
                DrawMarker(2, Config.Locations['Boat']['X'], Config.Locations['Boat']['Y'], Config.Locations['Boat']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 48, 255, 58, 255, false, false, false, 1, false, false, false)
                DrawText3D(Config.Locations['Boat']['X'], Config.Locations['Boat']['Y'], Config.Locations['Boat']['Z'] + 0.15, '~g~E~s~ - Boot Huren ~g~€~s~500')
                if IsControlJustReleased(0, 38) then
                    Framework.Functions.TriggerCallback("fw-fishing:server:can:pay", function(DidPay)
                        if DidPay then
                            HasPayedForBoat = true
                            SpawnFishBoat()
                        end
                    end, Config.BoatPrice)
                end
            end

            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 1478.07, 3788.75, 31.14, true)
            if Distance <= 5.0 then
                NearArea = true
                DrawMarker(2, 1478.07, 3788.75, 31.14, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 48, 255, 58, 255, false, false, false, 1, false, false, false)
                DrawText3D(1478.07, 3788.75, 31.14 + 0.15, '~g~E~s~ - Boot Terug Brengen ~g~+€~s~500')
                if IsControlJustReleased(0, 38) then
                    if HasPayedForBoat then
                        local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                        HasPayedForBoat = false
                        Framework.Functions.DeleteVehicle(Vehicle)
                        TriggerServerEvent('fw-fishing:server:repay:bail')
                        SetEntityCoords(GetPlayerPed(-1), 1552.42, 3797.91, 34.25)
                    else
                        Framework.Functions.Notify('Je hebt niet voor deze boot betaald..', 'error')
                    end
                end
            end

            if not NearArea then
                Citizen.Wait(1500)
            end
        end
    end
end)

RegisterNetEvent('fw-fishing:client:rod:anim')
AddEventHandler('fw-fishing:client:rod:anim', function()
    exports['fw-assets']:AddProp('FishingRod')
    exports['fw-assets']:RequestAnimationDict('amb@world_human_stand_fishing@idle_a')
    TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_stand_fishing@idle_a", "idle_a", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
end)

RegisterNetEvent('fw-fishing:client:use:fishingrod')
AddEventHandler('fw-fishing:client:use:fishingrod', function()
  Citizen.SetTimeout(1000, function()
      if not Config.UsingRod then
       if Config.CanFish then
          if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
           if not IsEntityInWater(GetPlayerPed(-1)) then
               Config.UsingRod = true
               FreezeEntityPosition(GetPlayerPed(-1), true)
               local Skillbar = exports['fw-skillbar']:GetSkillbarObject()
               local SucceededAttempts = 0
               local NeededAttempts = math.random(2, 5)
               TriggerEvent('fw-fishing:client:rod:anim')
               Skillbar.Start({
                   duration = math.random(500, 1300),
                   pos = math.random(10, 30),
                   width = math.random(10, 20),
               }, function()
                   if SucceededAttempts + 1 >= NeededAttempts then
                       -- Finish
                       FreezeEntityPosition(GetPlayerPed(-1), false)
                       exports['fw-assets']:RemoveProp()
                       Config.UsingRod = false
                       SucceededAttempts = 0
                       TriggerServerEvent('fw-fishing:server:fish:reward')
                       StopAnimTask(GetPlayerPed(-1), "amb@world_human_stand_fishing@idle_a", "idle_a", 1.0)
                   else
                       -- Repeat
                       Skillbar.Repeat({
                           duration = math.random(500, 1300),
                           pos = math.random(10, 40),
                           width = math.random(5, 13),
                       })
                       SucceededAttempts = SucceededAttempts + 1
                   end
               end, function()
                   -- Fail
                   FreezeEntityPosition(GetPlayerPed(-1), false)
                   exports['fw-assets']:RemoveProp()
                   Config.UsingRod = false
                   Framework.Functions.Notify('Je faalde..', 'error')
                   SucceededAttempts = 0
                   StopAnimTask(GetPlayerPed(-1), "amb@world_human_stand_fishing@idle_a", "idle_a", 1.0)
               end)
           else
               Framework.Functions.Notify('Je bent aan het zwemmen nerd..', 'error')
           end
          else
              Framework.Functions.Notify('Je zit in een voertuig..', 'error')
          end
       else
           Framework.Functions.Notify('Je bent niet eens in een vis gebied..', 'error')
       end
      end
  end)
end)

function SetRandomLocation()
    RandomLocation = Config.FishLocations[math.random(1, #Config.FishLocations)]
    if CurrentLocation['Name'] ~= RandomLocation['Name'] then
     if CurrentBlip ~= nil and CurrentRadiosBlip ~= nil then
      RemoveBlip(CurrentBlip)
      RemoveBlip(CurrentRadiosBlip)
     end
     Citizen.SetTimeout(250, function()
         CurrentRadiosBlip = AddBlipForRadius(RandomLocation['Coords']['X'], RandomLocation['Coords']['Y'], RandomLocation['Coords']['Z'], 75.0)        
         SetBlipRotation(CurrentRadiosBlip, 0)
         SetBlipColour(CurrentRadiosBlip, 19)
     
         CurrentBlip = AddBlipForCoord(RandomLocation['Coords']['X'], RandomLocation['Coords']['Y'], RandomLocation['Coords']['Z'])
         SetBlipSprite(CurrentBlip, 68)
         SetBlipDisplay(CurrentBlip, 4)
         SetBlipScale(CurrentBlip, 0.7)
         SetBlipColour(CurrentBlip, 0)
         SetBlipAsShortRange(CurrentBlip, true)
         BeginTextCommandSetBlipName('STRING')
         AddTextComponentSubstringPlayerName('Visgebied')
         EndTextCommandSetBlipName(CurrentBlip)
         CurrentLocation = RandomLocation
     end)
    else
        SetRandomLocation()
    end
end

function SpawnFishBoat()
    local CoordTable = {x = 1517.25, y = 3836.86, z = 29.60, a = 37.31}
    Framework.Functions.SpawnVehicle('dinghy', function(vehicle)
     TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
     exports['fw-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(vehicle), true)
     Citizen.Wait(100)
     exports['fw-fuel']:SetFuelLevel(vehicle, GetVehicleNumberPlateText(vehicle), 100, true)
     Framework.Functions.Notify('Succesvol voertuig ingespawned!', 'success')
    end, CoordTable, true, true)
end

-- // Functions \\ --

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