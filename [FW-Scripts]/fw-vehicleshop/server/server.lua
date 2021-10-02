Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

Framework.Functions.CreateCallback('fw-vehicleshop:server:get:config', function(source, cb)
    cb(Config)
end)

Framework.Functions.CreateCallback('fw-vehicleshop:server:check:owner', function(source, cb, plate)
    local Player = Framework.Functions.GetPlayer(source)
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterNetEvent('fw-vehicleshop:server:sell:vehicle')
AddEventHandler('fw-vehicleshop:server:sell:vehicle', function(Plate, Price)
    local Player = Framework.Functions.GetPlayer(source)
    local PriceCalc = (Price / 100) * math.random(60, 70)
    Player.Functions.AddMoney("bank", PriceCalc, "vehicle-sell")
    TriggerClientEvent('Framework:Notify', source, "Je hebt je voertuig verkocht voor €" .. PriceCalc .. "!", 'success')
    Framework.Functions.ExecuteSql(false, "DELETE FROM characters_vehicles WHERE citizenid = '"..Player.PlayerData.citizenid.."' AND plate = '"..Plate.."'")
end)

Framework.Commands.Add("refreshcars", "Refresh de car dealer", {}, false, function(source, args)
    local RandomSport = Config.RandomVehicles['sport'][math.random(1, #Config.RandomVehicles['sport'])]
    local RandomSedan = Config.RandomVehicles['sedan'][math.random(1, #Config.RandomVehicles['sedan'])]
    local RandomMotor = Config.RandomVehicles['motors'][math.random(1, #Config.RandomVehicles['motors'])]
    local RandomMuscle = Config.RandomVehicles['muscle'][math.random(1, #Config.RandomVehicles['muscle'])]
    local RandomVans = Config.RandomVehicles['vans'][math.random(1, #Config.RandomVehicles['vans'])]
    local RandomAddon = Config.RandomVehicles['addon'][math.random(1, #Config.RandomVehicles['addon'])]
    Citizen.SetTimeout(1500, function()
        Config.Vehicles[1]['current-vehicle'] = RandomSport
        Config.Vehicles[2]['current-vehicle'] = RandomSedan
        Config.Vehicles[3]['current-vehicle'] = RandomMotor
        Config.Vehicles[4]['current-vehicle'] = RandomMuscle
        Config.Vehicles[5]['current-vehicle'] = RandomVans
        Config.Vehicles[6]['current-vehicle'] = RandomAddon
        TriggerClientEvent('fw-vehicleshop:client:set:vehicles', -1, RandomSport, RandomSedan, RandomMotor, RandomMuscle, RandomVans, RandomAddon)
    end)
end, "admin")

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        local RandomSport = Config.RandomVehicles['sport'][math.random(1, #Config.RandomVehicles['sport'])]
        local RandomSedan = Config.RandomVehicles['sedan'][math.random(1, #Config.RandomVehicles['sedan'])]
        local RandomMotor = Config.RandomVehicles['motors'][math.random(1, #Config.RandomVehicles['motors'])]
        local RandomMuscle = Config.RandomVehicles['muscle'][math.random(1, #Config.RandomVehicles['muscle'])]
        local RandomVans = Config.RandomVehicles['vans'][math.random(1, #Config.RandomVehicles['vans'])]
        local RandomAddon = Config.RandomVehicles['addon'][math.random(1, #Config.RandomVehicles['addon'])]
        Citizen.SetTimeout(1500, function()
            Config.Vehicles[1]['current-vehicle'] = RandomSport
            Config.Vehicles[2]['current-vehicle'] = RandomSedan
            Config.Vehicles[3]['current-vehicle'] = RandomMotor
            Config.Vehicles[4]['current-vehicle'] = RandomMuscle
            Config.Vehicles[5]['current-vehicle'] = RandomVans
            Config.Vehicles[6]['current-vehicle'] = RandomAddon
            TriggerClientEvent('fw-vehicleshop:client:set:vehicles', -1, RandomSport, RandomSedan, RandomMotor, RandomMuscle, RandomVans, RandomAddon)
        end)
        Citizen.Wait((1000 * 60) * 20)
    end
end)

RegisterServerEvent('fw-vehicleshop:server:buy:vehicle')
AddEventHandler('fw-vehicleshop:server:buy:vehicle', function(Vehicle, Price)
    local src = source
    local GarageData = 'Blokken Parking'
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
    local Player = Framework.Functions.GetPlayer(src)
    local BankBalance = Player.PlayerData.money['bank']
    local Plate = GeneratePlate()
    if BankBalance >= Price then
        Player.Functions.RemoveMoney("bank", Price, "vehicle-shop")
        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..Player.PlayerData.citizenid.."', '"..Vehicle.."', '"..Plate.."', '"..GarageData.."', 'out', '{}', '"..json.encode(VehicleMeta).."')")
        TriggerClientEvent('fw-vehicleshop:client:spawn:bought:vehicle', src, Vehicle, Plate)
    else
        TriggerClientEvent('Framework:Notify', src, "Je hebt niet genoeg geld op de bank..", 'error')
    end
end)

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