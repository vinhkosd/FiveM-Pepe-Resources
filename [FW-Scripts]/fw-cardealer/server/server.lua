local Framework = nil

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Citizen.CreateThread(function()
    Citizen.SetTimeout(1000, function()
        Framework.Functions.ExecuteSql(false, "SELECT * FROM `server-cars` WHERE `type` = 'premium'", function(result)
            for k, v in pairs(result) do
                Config.PremiumVehicleDetails[v.vehiclename] = {['Price'] = v.price, ['Display'] = v.vehicledisplayname, ['Stock'] = v.stock}
                TriggerClientEvent('fw-cardealer:client:set:premium:details', -1, v.vehiclename, v.price, v.vehicledisplayname, v.stock)
                Citizen.Wait(3)
            end
        end)
    end)
end)

Framework.Functions.CreateCallback("fw-cardealer:server:get:config", function(source, cb)
    cb(Config)
end)

Framework.Functions.CreateCallback("fw-cardealer:server:get:storage:cars", function(source, cb)
    local CarsTable = {}
    Framework.Functions.ExecuteSql(true, "SELECT * FROM `server-cars` WHERE `type` = 'premium'", function(result)
        for k, v in pairs(result) do
            local TempTable = {}
            TempTable = {
                ['VehicleDisplayName'] = v.vehicledisplayname,
                ['VehicleName'] = v.vehiclename,
                ['VehicleBrand'] = v.vehiclebrand,
                ['VehicleClass'] = v.vehicleclass,
                ['VehicleStock'] = v.stock,
                ['VehiclePrice'] = v.price
            }
            table.insert(CarsTable, TempTable)
        end
        cb(CarsTable)
    end)
end)

RegisterServerEvent('fw-cardealer:server:set:premium:data')
AddEventHandler('fw-cardealer:server:set:premium:data', function(Slot, Price, Model, DisplayName, Stock)
 print("Slot"..Slot)
 print("Model"..json.encode(Model))
 print("Price"..Price)
 Config.PremiumDealerSpots[Slot]['Price'] = tonumber(Price)
 Config.PremiumDealerSpots[Slot]['DisplayName'] = DisplayName
 Config.PremiumDealerSpots[Slot]['Model'] = Model
 Config.PremiumDealerSpots[Slot]['Stock'] = Stock
 TriggerClientEvent('fw-cardealer:client:sync:premium:dealer', -1, Slot, Config.PremiumDealerSpots[Slot])
end)

RegisterServerEvent('fw-cardealer:server:sell:closest')
AddEventHandler('fw-cardealer:server:sell:closest', function(TargetPlayer, CurrentSlot)
    local TargetSource = Framework.Functions.GetPlayer(TargetPlayer)
    if TargetSource ~= nil then
        TriggerClientEvent('fw-cardealer:client:can:buy:vehicle', TargetSource.PlayerData.source, CurrentSlot)
    end
end)

RegisterServerEvent('fw-cardealer:server:buy:current:vehicle')
AddEventHandler('fw-cardealer:server:buy:current:vehicle', function(CurrentSlot)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    if Config.PremiumDealerSpots[CurrentSlot]['Stock'] > 0 then
        if Player.Functions.RemoveMoney("bank", Config.PremiumDealerSpots[CurrentSlot]['Price'], "vehicle-shop") then
            local Plate = GeneratePlate()
            local GarageData = 'Blokken Parking'
            local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
            local NewStock = Config.PremiumDealerSpots[CurrentSlot]['Stock'] - 1  
            Config.PremiumDealerSpots[CurrentSlot]['Stock'] = NewStock
            Framework.Functions.ExecuteSql(false, "UPDATE `server-cars` SET stock = '"..NewStock.."' WHERE `vehiclename` = '"..Config.PremiumDealerSpots[CurrentSlot]['Model'].."'")
            Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..Player.PlayerData.citizenid.."', '"..Config.PremiumDealerSpots[CurrentSlot]['Model'].."', '"..Plate.."', '"..GarageData.."', 'out', '{}', '"..json.encode(VehicleMeta).."')")
            TriggerClientEvent('fw-cardealer:client:set:stock', -1, NewStock, CurrentSlot)
            TriggerClientEvent('fw-cardealer:client:spawn:car:premium', src, Config.PremiumDealerSpots[CurrentSlot]['Model'], Plate, NewStock, CurrentSlot)
        else
            TriggerClientEvent('Framework:Notify', src, "Je hebt niet genoeg bank saldo..", 'error', 5500)
        end
    else
        TriggerClientEvent('Framework:Notify', src, "Dit voertuig is niet op voorraad..", 'error', 5500)
    end
end)

function RefreshCarDealer()
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `server-cars` WHERE `type` = 'premium'", function(result)
        for k, v in pairs(result) do
            Config.PremiumVehicleDetails[v.vehiclename] = {['Price'] = v.price, ['Display'] = v.vehicledisplayname, ['Stock'] = v.stock}
            TriggerClientEvent('fw-cardealer:client:set:premium:details', -1, v.vehiclename, v.price, v.vehicledisplayname, v.stock)
            Citizen.Wait(3)
        end
    end)
end

function GeneratePlate()
    local plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        while (result[1] ~= nil) do
            plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
        end
        return plate
    end)
    return plate:upper()
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end