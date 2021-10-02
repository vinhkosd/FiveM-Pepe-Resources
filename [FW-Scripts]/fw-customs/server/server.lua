Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('lscustoms:server:setGarageBusy')
AddEventHandler('lscustoms:server:setGarageBusy', function(garage, busy)
	TriggerClientEvent('lscustoms:client:setGarageBusy', -1, garage, busy)
end)

RegisterServerEvent("LSC:buttonSelected")
AddEventHandler("LSC:buttonSelected", function(name, button)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	if not button.purchased then
		if button.price then -- check if button have price
			if Player.Functions.RemoveMoney("cash", button.price, "lscustoms-bought") then
				TriggerClientEvent("LSC:buttonSelected", source, name, button, true)
				TriggerEvent("fw-logs:server:SendLog", "vehicleupgrades", "Upgrade gekocht", "green", "**"..GetPlayerName(src).."** heeft en upgrade gekocht ("..name..") voor €" .. button.price)
			elseif Player.Functions.RemoveMoney("bank", button.price, "lscustoms-bought") then
				TriggerClientEvent("LSC:buttonSelected", source, name, button, true)
				TriggerEvent("fw-logs:server:SendLog", "vehicleupgrades", "Upgrade gekocht", "green", "**"..GetPlayerName(src).."** heeft en upgrade gekocht ("..name..") voor €" .. button.price)
			else
				TriggerClientEvent("LSC:buttonSelected", source, name, button, false)
			end
		end
	else
		TriggerClientEvent("LSC:buttonSelected", source, name, button, false)
	end
end)

RegisterServerEvent("lscustoms:server:SaveVehicleProps")
AddEventHandler("lscustoms:server:SaveVehicleProps", function(vehicleProps)
	local src = source
    if IsVehicleOwned(vehicleProps.plate) then
        Framework.Functions.ExecuteSql(false, "UPDATE `characters_vehicles` SET `mods` = '"..json.encode(vehicleProps).."' WHERE `plate` = '"..vehicleProps.plate.."'")
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
    end)
    return retval
end