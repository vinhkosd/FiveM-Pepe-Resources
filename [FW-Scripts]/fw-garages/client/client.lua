local LoggedIn = false
local Framework = nil
local NearGarage = false
local IsMenuActive = false   

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
     Citizen.Wait(250)
     LoggedIn = true
 end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(4)
    if LoggedIn then
        NearGarage = false
        for k, v in pairs(Config.GarageLocations) do
          local Distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v["Coords"]["X"], v["Coords"]["Y"], v["Coords"]["Z"], true) 
          if Distance < v['Distance'] then
           NearGarage = true
           Config.CurrentGarageData = {['GarageNumber'] = k, ['GarageName'] = v['Name']}
          end
        end
        if not NearGarage then
          Citizen.Wait(1500)
          Config.CurrentGarageData = {}
        end
    end
  end
end)

-- // Events \\ --

RegisterNetEvent('fw-garages:client:check:owner')
AddEventHandler('fw-garages:client:check:owner', function()
local Vehicle, VehDistance = Framework.Functions.GetClosestVehicle()
local Plate = GetVehicleNumberPlateText(Vehicle)
  if VehDistance < 2.3 then
     Framework.Functions.TriggerCallback("fw-garage:server:is:vehicle:owner", function(IsOwner)
         if IsOwner then
           TriggerEvent('fw-garages:client:set:vehicle:in:garage', Vehicle, Plate)
         else
          Framework.Functions.Notify('Đây không phải xe của bạn..', 'error')
         end
     end, Plate)
  else
    Framework.Functions.Notify('Không có phương tiện nào ở gần??', 'error')
  end
end)

RegisterNetEvent('fw-garages:client:set:vehicle:in:garage')
AddEventHandler('fw-garages:client:set:vehicle:in:garage', function(Vehicle, Plate)
   local VehicleMeta = {Fuel = exports['fw-fuel']:GetFuelLevel(Plate), Body = GetVehicleBodyHealth(Vehicle), Engine = GetVehicleEngineHealth(Vehicle)}
   local GarageData = Config.CurrentGarageData['GarageName']
    TaskLeaveAnyVehicle(GetPlayerPed(-1))
    Citizen.SetTimeout(1650, function()
      TriggerServerEvent('fw-garages:server:set:in:garage', Plate, GarageData, 'in', VehicleMeta)
      Framework.Functions.DeleteVehicle(Vehicle)
      Framework.Functions.Notify('Xe đã cất ở Ga-ra: '..Config.CurrentGarageData['GarageName'], 'success')
    end)
end)

RegisterNetEvent('fw-garages:client:set:vehicle:out:garage')
AddEventHandler('fw-garages:client:set:vehicle:out:garage', function()
  OpenGarageMenu()
end)

RegisterNetEvent('fw-garages:client:open:depot')
AddEventHandler('fw-garages:client:open:depot', function()
  OpenDepotMenu()
end)

RegisterNetEvent('fw-garages:client:spawn:vehicle')
AddEventHandler('fw-garages:client:spawn:vehicle', function(Plate, VehicleName, Metadata)
  local RandomCoords = Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'][math.random(1, #Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'])]['Coords']
  local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}
  Framework.Functions.SpawnVehicle(VehicleName, function(Vehicle)
    SetVehicleNumberPlateText(Vehicle, Plate)
    DoCarDamage(Vehicle, Metadata.Engine, Metadata.Body)
    Citizen.Wait(25)
    exports['fw-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
    exports['fw-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), Metadata.Fuel, false)
    Framework.Functions.Notify('Xe của bạn đang nằm ở bãi đỗ xe', 'success')
  end, CoordTable, true, false)
end)

RegisterNUICallback('Click', function()
  PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('CloseNui', function()
  SetNuiFocus(false, false)
end)

RegisterNUICallback('TakeOutVehicle', function(data)
  if IsNearGarage() then
    local RandomCoords = Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'][math.random(1, #Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'])]['Coords']
    local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}
    if data.State == 'in' then
      Framework.Functions.SpawnVehicle(data.Model, function(Vehicle)
        Framework.Functions.TriggerCallback('fw-garage:server:get:vehicle:mods', function(Mods)
          Framework.Functions.SetVehicleProperties(Vehicle, Mods)
          SetVehicleNumberPlateText(Vehicle, data.Plate)
          Citizen.Wait(25)
          DoCarDamage(Vehicle, data.Engine, data.Body)
          Citizen.Wait(25)
          exports['fw-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
          exports['fw-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), data.Fuel, false)
          Framework.Functions.Notify('Xe của bạn đang nằm ở bãi đỗ xe', 'info')
          TriggerServerEvent('fw-garages:server:set:garage:state', data.Plate, 'out')
        end, data.Plate)
      end, CoordTable, true, false)
    else
        Framework.Functions.Notify("Xe của bạn không nằm trong Ga-ra??", "info", 3500)
    end
  elseif IsNearDepot() then
    Framework.Functions.TriggerCallback('fw-garage:server:pay:depot', function(DidPayment)
      if DidPayment then
        local CoordTable = {x = 491.59, y = -1314.14, z = 29.25, a = 299.67}
        Framework.Functions.SpawnVehicle(data.Model, function(Vehicle)
        Framework.Functions.TriggerCallback('fw-garage:server:get:vehicle:mods', function(Mods)
        Framework.Functions.SetVehicleProperties(Vehicle, Mods)
          SetVehicleNumberPlateText(Vehicle, data.Plate)
          Citizen.Wait(25)
          DoCarDamage(Vehicle, data.Engine, data.Body)
          Citizen.Wait(25)
          TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vehicle, -1)
          exports['fw-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
          exports['fw-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), data.Fuel, false)
          Framework.Functions.Notify('Xe được lấy khỏi ga-ra', 'success')
          TriggerServerEvent('fw-garages:server:set:depot:price', data.Plate, 0)
          TriggerServerEvent('fw-garages:server:set:garage:state', data.Plate, 'out')
          CloseMenuFull()
          end, data.Plate)
        end, CoordTable, true, false)
      end
    end, data.Price)
  elseif exports['fw-housing']:NearHouseGarage() then
    if data.State == 'in' then
      local VehicleSpawn = exports['fw-housing']:GetGarageCoords()
      local CoordTable = {x = VehicleSpawn['X'], y = VehicleSpawn['Y'], z = VehicleSpawn['Z'], a = VehicleSpawn['H']}
      Framework.Functions.SpawnVehicle(data.Model, function(Vehicle)
        Framework.Functions.TriggerCallback('fw-garage:server:get:vehicle:mods', function(Mods)
             Framework.Functions.SetVehicleProperties(Vehicle, Mods)
             SetVehicleNumberPlateText(Vehicle, data.Plate)
             Citizen.Wait(25)
             DoCarDamage(Vehicle, data.Engine, data.Body)
             Citizen.Wait(25)
             TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vehicle, -1)
             exports['fw-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
             exports['fw-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), data.Fuel, false)
             Framework.Functions.Notify('Xe được lấy khỏi ga-ra', 'success')
             TriggerServerEvent('fw-garages:server:set:garage:state', data.Plate, 'out')
             CloseMenuFull()
           end, data.Plate)
        end, CoordTable, true, false)
      else
        Framework.Functions.Notify("Xe không nằm trong ga-ra??", "info", 3500)
    end
  end
end)

-- // Functions \\ --

function DoCarDamage(Vehicle, EngineHealth, BodyHealth)
	SmashWindows = false
	damageOutside = false
	damageOutside2 = false 
	local engine = EngineHealth + 0.0
	local body = BodyHealth + 0.0
	if engine < 200.0 then
		engine = 200.0
	end

	if body < 150.0 then
		body = 150.0
	end
	if body < 950.0 then
		SmashWindows = true
	end

	if body < 920.0 then
		damageOutside = true
	end

	if body < 920.0 then
		damageOutside2 = true
	end
	Citizen.Wait(100)
	SetVehicleEngineHealth(Vehicle, engine)
	if SmashWindows then
		SmashVehicleWindow(Vehicle, 0)
		SmashVehicleWindow(Vehicle, 1)
		SmashVehicleWindow(Vehicle, 2)
		SmashVehicleWindow(Vehicle, 3)
		SmashVehicleWindow(Vehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(Vehicle, 1, true)
		SetVehicleDoorBroken(Vehicle, 6, true)
		SetVehicleDoorBroken(Vehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(Vehicle, 1, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 2, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 3, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(Vehicle, 985.0)
  end
end

function IsNearGarage()
  return NearGarage
end

function IsNearDepot()
  local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
  local Distance = GetDistanceBetweenCoords(PlayerCoords, 491.03, -1313.82, 29.25, true) 
  if Distance < 10.0 then
    return true
  end
end

function OpenGarageMenu()
  local VehicleTable = {}
  PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  Framework.Functions.TriggerCallback("fw-garage:server:GetUserVehicles", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
             local Vehicle = {}
             local MetaData = json.decode(v.metadata)
             Vehicle = {['Name'] = Framework.Shared.Vehicles[v.vehicle]['Name'], ['Model'] = v.vehicle, ['Plate'] = v.plate, ['Garage'] = v.garage,['State'] = v.state, ['Fuel'] = MetaData.Fuel, ['Motor'] = math.ceil(MetaData.Engine), ['Body'] = math.ceil(MetaData.Body)}
             table.insert(VehicleTable, Vehicle) 
          end
          SetNuiFocus(true, true)
          Citizen.InvokeNative(0xFC695459D4D0E219, 0.9, 0.25)
          SendNUIMessage({action = "OpenGarage", garagevehicles = VehicleTable})
      else
        Framework.Functions.Notify("Bạn không có phương tiện nào trong ga-ra này..", "error", 5000)
      end
  end, Config.CurrentGarageData['GarageName'])
end

function OpenDepotMenu()
  local VehicleTable = {}
  PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  Framework.Functions.TriggerCallback("fw-garage:server:GetDepotVehicles", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              if v.state == 'out' then
                local Vehicle = {}
                local MetaData = json.decode(v.metadata)
                Vehicle = {['Name'] = Framework.Shared.Vehicles[v.vehicle]['Name'], ['Model'] = v.vehicle, ['Plate'] = v.plate, ['Garage'] = v.garage, ['State'] = v.state, ['Price'] = v.depotprice, ['Fuel'] = MetaData.Fuel, ['Motor'] = math.ceil(MetaData.Engine), ['Body'] = math.ceil(MetaData.Body)}
                table.insert(VehicleTable, Vehicle)
              end 
          end
          SetNuiFocus(true, true)
          Citizen.InvokeNative(0xFC695459D4D0E219, 0.9, 0.25)
          SendNUIMessage({action = "OpenDepot", depotvehicles = VehicleTable})
      else
        Framework.Functions.Notify("Ga-ra trống..", "error", 5000)
      end
  end)
end

function OpenHouseGarage(HouseId)
  local VehicleTable = {}
  PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  Framework.Functions.TriggerCallback("fw-garage:server:GetHouseVehicles", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              local Vehicle = {}
              local MetaData = json.decode(v.metadata)
              Vehicle = {['Name'] = Framework.Shared.Vehicles[v.vehicle]['Name'], ['Model'] = v.vehicle, ['Plate'] = v.plate, ['Garage'] = v.garage, ['State'] = v.state, ['Fuel'] = MetaData.Fuel, ['Motor'] = math.ceil(MetaData.Engine), ['Body'] = math.ceil(MetaData.Body)}
              table.insert(VehicleTable, Vehicle)
          end
          SetNuiFocus(true, true)
          Citizen.InvokeNative(0xFC695459D4D0E219, 0.9, 0.25)
          SendNUIMessage({action = "OpenGarage", garagevehicles = VehicleTable})
      else
        Framework.Functions.Notify("Bạn không có phương tiện nào trong ga-ra này", "error", 5000)
      end
  end, HouseId)
end

function SetVehicleInHouseGarage(HouseId)
  local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
  local Plate = GetVehicleNumberPlateText(Vehicle)
  local VehicleMeta = {Fuel = exports['fw-fuel']:GetFuelLevel(Plate), Body = GetVehicleBodyHealth(Vehicle), Engine = GetVehicleEngineHealth(Vehicle)}
  local GarageData = HouseId
  TaskLeaveAnyVehicle(GetPlayerPed(-1))
  Citizen.SetTimeout(1650, function()
    TriggerServerEvent('fw-garages:server:set:in:garage', Plate, GarageData, 'in', VehicleMeta)
    Framework.Functions.DeleteVehicle(Vehicle)
    Framework.Functions.Notify('Xe của bạn đã được đỗ tại: '..HouseId, 'success')
  end)
end