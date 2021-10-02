Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback("fw-garage:server:is:vehicle:owner", function(source, cb, plate)
    Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..PlateEscapeSqli(plate).."'", function(result)
        local Player = Framework.Functions.GetPlayer(source)
        if result[1] ~= nil then
            if result[1].citizenid == Player.PlayerData.citizenid then
              cb(true)
            else
              cb(false)
            end
        else
            cb(false)
        end
    end)
end)

Framework.Functions.CreateCallback("fw-garage:server:GetHouseVehicles", function(source, cb, HouseId)
  Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `garage` = '"..HouseId.."'", function(result)
    if result ~= nil then
      cb(result)
    end 
  end)
end)

Framework.Functions.CreateCallback("fw-garage:server:GetUserVehicles", function(source, cb, garagename)
  local src = source
  local Player = Framework.Functions.GetPlayer(src)
  Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND garage = '"..garagename.."'", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              cb(result)
          end
      end
      cb(nil)
  end)
end)

Framework.Functions.CreateCallback("fw-garage:server:GetDepotVehicles", function(source, cb)
  local src = source
  local Player = Framework.Functions.GetPlayer(src)
  Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              cb(result)
          end
      end
      cb(nil)
  end)
end)

Framework.Functions.CreateCallback("fw-garage:server:pay:depot", function(source, cb, price)
  local src = source
  local Player = Framework.Functions.GetPlayer(src)
  if Player.Functions.RemoveMoney("cash", price, "Depot Paid") then
    cb(true)
  else
    TriggerClientEvent('Framework:Notify', src, "Je hebt niet genoeg contant..", "error")
    cb(false)
  end
end)

Framework.Functions.CreateCallback("fw-garage:server:get:vehicle:mods", function(source, cb, plate)
  local src = source
  local properties = {}
  Framework.Functions.ExecuteSql(false, "SELECT `mods` FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
      if result[1] ~= nil then
          properties = json.decode(result[1].mods)
      end
      cb(properties)
  end)
end)

RegisterServerEvent('fw-garages:server:set:in:garage')
AddEventHandler('fw-garages:server:set:in:garage', function(Plate, GarageData, Status, MetaData)
 TriggerEvent('fw-garages:server:set:garage:state', Plate, 'in')
 Framework.Functions.ExecuteSql(true, "UPDATE `characters_vehicles` SET garage = '" ..GarageData.. "', state = '"..Status.."', metadata = '"..json.encode(MetaData).."' WHERE `plate` = '"..PlateEscapeSqli(Plate).."'")
end)

RegisterServerEvent('fw-garages:server:set:garage:state')
AddEventHandler('fw-garages:server:set:garage:state', function(Plate, Status)
  Framework.Functions.ExecuteSql(true, "UPDATE `characters_vehicles` SET state = '"..Status.."' WHERE `plate` = '"..PlateEscapeSqli(Plate).."'")
end)

RegisterServerEvent('fw-garages:server:set:depot:price')
AddEventHandler('fw-garages:server:set:depot:price', function(Plate, Price)
  Framework.Functions.ExecuteSql(true, "UPDATE `characters_vehicles` SET depotprice = '"..Price.."' WHERE `plate` = '"..PlateEscapeSqli(Plate).."'")
end)

-- // Server Function \\ --

function PlateEscapeSqli(str)
	if str:len() <= 8 then 
	 local replacements = { ['"'] = '\\"', ["'"] = "\\'"}
	 return str:gsub( "['\"]", replacements)
	end
end