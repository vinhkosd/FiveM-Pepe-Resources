Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback('fw-banktruck:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('fw-banktruck:server:OpenTruck')
AddEventHandler('fw-banktruck:server:OpenTruck', function(Veh) 
    TriggerClientEvent('fw-banktruck:client:OpenTruck', source, Veh)
end)

RegisterServerEvent('fw-banktruck:server:updateplates')
AddEventHandler('fw-banktruck:server:updateplates', function(Plate)
 Config.RobbedPlates[Plate] = true
 TriggerClientEvent('fw-banktruck:plate:table', -1, Plate)
end)

RegisterServerEvent('fw-banktruck:sever:send:cop:alert')
AddEventHandler('fw-banktruck:sever:send:cop:alert', function(coords, veh, plate)
    local msg = "Er wordt een geld wagen overvallen.<br>"..plate
    local alertData = {
        title = "Geld Wagen Alarm",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("fw-banktruck:client:send:cop:alert", -1, coords, veh, plate)
    TriggerClientEvent("fw-phone:client:addPoliceAlert", -1, alertData)
end)

RegisterServerEvent('fw-bankrob:server:remove:card')
AddEventHandler('fw-bankrob:server:remove:card', function()
local Player = Framework.Functions.GetPlayer(source)
 Player.Functions.RemoveItem('green-card', 1)
 TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['green-card'], "remove")
end)

RegisterServerEvent('blijf:uit:mijn:scripts:rewards')
AddEventHandler('blijf:uit:mijn:scripts:rewards', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local RandomWaarde = math.random(1,100)
    if RandomWaarde >= 1 and RandomWaarde <= 30 then
    local info = {worth = math.random(7500, 12500)}
    Player.Functions.AddItem('markedbills', 1, false, info)
    TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items['markedbills'], "add")
    TriggerEvent("fw-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Speler:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Gekregen: **Marked Bills\n**Waarde: **"..info.worth)
    elseif RandomWaarde >= 31 and RandomWaarde <= 50 then
        local AmountGoldStuff = math.random(6,25)
        Player.Functions.AddItem('gold-rolex', AmountGoldStuff)
        TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items['gold-rolex'], "add")
    elseif RandomWaarde >= 51 and RandomWaarde <= 80 then 
        local AmountGoldStuff = math.random(6,25)
        Player.Functions.AddItem('gold-necklace', AmountGoldStuff)
        TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items['gold-necklace'], "add")
        TriggerEvent("fw-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Speler:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Gekregen: **Gouden Ketting\n**Aantal: **"..AmountGoldStuff)
    elseif RandomWaarde == 91 or RandomWaarde == 98 or RandomWaarde == 85 or RandomWaarde == 65 then
        local RandomAmount = math.random(2,6)
        Player.Functions.AddItem('gold-bar', RandomAmount)
        TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items['gold-bar'], "add") 
        TriggerEvent("fw-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Speler:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Gekregen: **Goud Staaf\n**Aantal: **"..RandomAmount)
    elseif RandomWaarde == 26 or RandomWaarde == 52 then 
        Player.Functions.AddItem('yellow-card', 1)
        TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items['yellow-card'], "add") 
        TriggerEvent("fw-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Speler:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Gekregen: **Gele Kaart\n**Aantal:** 1x")
    end
end)

Framework.Functions.CreateUseableItem("green-card", function(source, item)
    TriggerClientEvent("fw-truckrob:client:UseCard", source)
end)