Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback("fw-houseplants:server:get:config", function(source, cb)
    cb(Config)
end)

Citizen.CreateThread(function()
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_house_plants`", function(result)
        for k, v in pairs(result) do
            Config.Plants[v.houseid] = json.decode(v.plants)
            TriggerClientEvent('fw-houseplants:client:sync:plant:data', -1, Config.Plants)
        end
    end)
end)

RegisterServerEvent('fw-houseplants:server:destroy:plant')
AddEventHandler('fw-houseplants:server:destroy:plant', function(HouseId, RemoveId, IsDead)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_house_plants` WHERE `houseid` = '"..HouseId.."'", function(result)
        local PlantData = json.decode(result[1].plants)
        local NewPlants = {}
        for k, v in pairs(PlantData) do
            if k ~= RemoveId then
              table.insert(NewPlants, v)
            end
        end
        Framework.Functions.ExecuteSql(false, "UPDATE `characters_house_plants` SET `plants` = '"..json.encode(NewPlants).."' WHERE `houseid` = '"..HouseId.."'")
        RefreshPlants(HouseId)
        if IsDead then
            Player.Functions.AddItem('wet-tak', math.random(1, 3))
            TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items['wet-tak'], "add")
        end
    end)
end)

RegisterServerEvent('fw-houseplants:server:add:plant')
AddEventHandler('fw-houseplants:server:add:plant', function(HouseId, NewPlant)
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_house_plants` WHERE `houseid` = '"..HouseId.."'", function(result)
        if result[1] ~= nil then
            Config.Plants[HouseId] = NewPlant
            SaveCurrentHousePlants(HouseId)
        else
            Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_house_plants` (`houseid`, `plants`) VALUES ('"..HouseId.."', '"..json.encode(NewPlant).."')")
            Citizen.SetTimeout(150, function()
                RefreshPlants(HouseId)
            end)
        end
    end)
end)

RegisterServerEvent('fw-houseplants:server:feed:plant')
AddEventHandler('fw-houseplants:server:feed:plant', function(HouseId, PlantId)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    if Config.Plants[HouseId] ~= nil then
       if Config.Plants[HouseId][PlantId]['Food'] < 100 then
            local RandomPlusAmouont = math.random(15, 25)
            if Config.Plants[HouseId][PlantId]['Food'] + RandomPlusAmouont < 100 then
                Config.Plants[HouseId][PlantId]['Food'] = Config.Plants[HouseId][PlantId]['Food'] + RandomPlusAmouont
                SaveCurrentHousePlants(HouseId)
            else
                Config.Plants[HouseId][PlantId]['Food'] = 100
                SaveCurrentHousePlants(HouseId)
            end
            TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items['weed-nutrition'], "remove")
            Player.Functions.RemoveItem('weed-nutrition', 1)
       end
    end
end)

RegisterServerEvent('fw-houseplants:server:harvest:plant')
AddEventHandler('fw-houseplants:server:harvest:plant', function(HouseId, PlantId, Amount)
   local src = source
   local Player = Framework.Functions.GetPlayer(src)
   local RandomWeedAmount = math.random(4, 8)
   local PlasticBag = Player.Functions.GetItemByName('plastic-bag')
   if Config.Plants[HouseId] ~= nil then
        if PlasticBag.amount >= RandomWeedAmount then
            Player.Functions.RemoveItem('plastic-bag', RandomWeedAmount)
            if Config.Plants[HouseId][PlantId]['Sort'] == 'White-Widow' then
                Player.Functions.AddItem('weed_white-widow', RandomWeedAmount)
                TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items['weed_white-widow'], "add")
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('skunk-seed', Amount)
                end
            elseif Config.Plants[HouseId][PlantId]['Sort'] == 'Skunk' then
                Player.Functions.AddItem('weed_skunk', RandomWeedAmount)
                TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items['weed_skunk'], "add")
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('purple-haze-seed', Amount)
                end
            elseif Config.Plants[HouseId][PlantId]['Sort'] == 'Purple-Haze' then
                Player.Functions.AddItem('weed_purple-haze', RandomWeedAmount)
                TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items['weed_purple-haze'], "add")
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('og-kush-seed', Amount)
                end
            elseif Config.Plants[HouseId][PlantId]['Sort'] == 'Og-Kush' then
                Player.Functions.AddItem('weed_og-kush', RandomWeedAmount)
                TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items['weed_og-kush'], "add")
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('amnesia-seed', Amount)
                end
            elseif Config.Plants[HouseId][PlantId]['Sort'] == 'Amnesia' then
                Player.Functions.AddItem('weed_amnesia', RandomWeedAmount)
                TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items['weed_amnesia'], "add")
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('ak47-seed', Amount)
                end
            elseif Config.Plants[HouseId][PlantId]['Sort'] == 'AK47' then
                Player.Functions.AddItem('weed_ak47', RandomWeedAmount)
                TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items['weed_ak47'], "add")
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('ak47-seed', Amount)
                end
            end
            TriggerEvent('fw-houseplants:server:destroy:plant', HouseId, PlantId, false)
        else
            TriggerClientEvent('Framework:Notify', src, 'Je hebt niet genoeg zakjes..', 'error', 3500)
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.SetTimeout(750, function()
        while true do
            local RandomValue = math.random(1, 3)
            for k, v in pairs(Config.Plants) do
                for weed, plant in pairs(v) do
                    if plant['Food'] > 0 and plant['Food'] - RandomValue > 0 then
                        plant['Food'] = plant['Food'] - RandomValue
                    else
                        plant['Food'] = 0
                    end
                    if plant['Food'] < 50 then
                        if plant['Health'] > 0 then
                            plant['Health'] = plant['Health'] - 5
                        else
                            plant['Health'] = 0
                        end
                    elseif plant['Food'] > 50 then
                        if plant['Health'] < 100 and plant['Health'] ~= 0 then
                            plant['Health'] = plant['Health'] + 5
                        else
                            plant['Health'] = 100
                        end
                    end
                    if plant['Health'] > 0 then
                        if plant['Progress'] < 100 then
                            local RandomGrowth = math.random(1, 3)
                            plant['Progress'] = plant['Progress'] + RandomGrowth
                            if plant['Progress'] >= 10 and plant['Progress'] < 20 then
                                plant['Stage'] = 'Stage-B'
                            elseif plant['Progress'] >= 20 and plant['Progress'] < 30 then
                                plant['Stage'] = 'Stage-C'
                            elseif plant['Progress'] >= 30 and plant['Progress'] < 40 then
                                plant['Stage'] = 'Stage-D'
                            elseif plant['Progress'] >= 40 and plant['Progress'] < 65 then
                                plant['Stage'] = 'Stage-E'
                            elseif plant['Progress'] >= 65 and plant['Progress'] < 70 then
                                plant['Stage'] = 'Stage-F'
                            elseif plant['Progress'] >= 70 and plant['Progress'] < 100 then
                                plant['Stage'] = 'Stage-G'
                            end
                        end
                    end
                end
            end
            SaveAllPlants()
            Citizen.Wait(14 * (60 * 1000))
        end
    end)
end)

function SaveCurrentHousePlants(HouseId)
    Framework.Functions.ExecuteSql(false, "UPDATE `characters_house_plants` SET `plants` = '"..json.encode(Config.Plants[HouseId]).."' WHERE `houseid` = '"..HouseId.."'")
    Citizen.SetTimeout(150, function()
        RefreshPlants(HouseId)
    end)
end

function SaveAllPlants()
    for k, v in pairs(Config.Plants) do
        Framework.Functions.ExecuteSql(false, "UPDATE `characters_house_plants` SET `plants` = '"..json.encode(Config.Plants[k]).."' WHERE `houseid` = '"..k.."'")
        Citizen.SetTimeout(150, function()
            RefreshPlants(k)
        end)
    end
end

function RefreshPlants(HouseId)
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_house_plants` WHERE `houseid` = '"..HouseId.."'", function(result)
        Config.Plants[HouseId] = json.decode(result[1].plants)
        TriggerClientEvent('fw-houseplants:client:sync:plant:data', -1, Config.Plants)
        TriggerClientEvent('fw-houseplants:client:sync:plants', -1, HouseId)
    end)
end