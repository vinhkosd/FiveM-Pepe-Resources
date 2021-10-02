local TotalGoldBars = 0

Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Citizen.CreateThread(function()
    Config.Locations['PawnShops'][1] = {['X'] = 414.33, ['Y'] = 343.49, ['Z'] = 102.50, ['Open-Time'] = 6, ['Close-Time'] = 12, ['Sell-Value'] = 1.0, ['Type'] = 'Gold'}
    Config.Locations['PawnShops'][2] = {['X'] = -1468.99, ['Y'] = -406.36, ['Z'] = 36.81, ['Open-Time'] = 12, ['Close-Time'] = 16, ['Sell-Value'] = 1.0, ['Type'] = 'Bars'}
    Config.Locations['Smeltery'][1] = {['X'] = 1109.91, ['Y'] = -2008.23, ['Z'] = 31.08}
    Config.Locations['Gold-Sell'][1] = {['X'] = 130.93, ['Y'] = -1772.32, ['Z'] = 29.74}
end)

Framework.Functions.CreateCallback('fw-pawnshop:server:get:config', function(source, cb)
    cb(Config)
end)

Framework.Functions.CreateCallback('fw-pawnshop:server:has:gold', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.Functions.GetItemByName("gold-necklace") ~= nil or Player.Functions.GetItemByName("gold-rolex") or Player.Functions.GetItemByName("diamond-ring") ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent('fw-pawnshop:server:sell:gold:items')
AddEventHandler('fw-pawnshop:server:sell:gold:items', function()
  local Player = Framework.Functions.GetPlayer(source)
  local Price = 0
  if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
     for k, v in pairs(Player.PlayerData.items) do
         if Config.ItemPrices[Player.PlayerData.items[k].name] ~= nil then
            Price = Price + (Config.ItemPrices[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
            Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
         end
     end
     if Price > 0 then
       Player.Functions.AddMoney("cash", Price, "sold-pawn-items")
       TriggerClientEvent('Framework:Notify', source, "Je hebt je goud verkocht")
     end
  end
end)

RegisterServerEvent('fw-pawnshop:server:sell:gold:bars')
AddEventHandler('fw-pawnshop:server:sell:gold:bars', function()
    local Player = Framework.Functions.GetPlayer(source)
    local GoldItem = Player.Functions.GetItemByName("gold-bar")
    Player.Functions.RemoveItem('gold-bar', GoldItem.amount)
    TriggerClientEvent("fw-inventory:client:ItemBox", source, Framework.Shared.Items['gold-bar'], "remove")
    Player.Functions.AddMoney("cash", math.random(3500, 5000) * GoldItem.amount, "sold-pawn-items")
end)

RegisterServerEvent('fw-pawnshop:server:smelt:gold')
AddEventHandler('fw-pawnshop:server:smelt:gold', function()
    local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
        for k, v in pairs(Player.PlayerData.items) do
            if Config.SmeltItems[Player.PlayerData.items[k].name] ~= nil then
               local ItemAmount = (Player.PlayerData.items[k].amount / Config.SmeltItems[Player.PlayerData.items[k].name])
                if ItemAmount >= 1 then
                    ItemAmount = math.ceil(Player.PlayerData.items[k].amount / Config.SmeltItems[Player.PlayerData.items[k].name])
                    if Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k) then
                        TriggerClientEvent("fw-inventory:client:ItemBox", source, Framework.Shared.Items[Player.PlayerData.items[k].name], "remove")
                        TotalGoldBars = TotalGoldBars + ItemAmount
                        if TotalGoldBars > 0 then
                          TriggerClientEvent('fw-pawnshop:client:start:process', -1)
                        end
                    end
                end
            end
        end
     end
end)

RegisterServerEvent('fw-pawnshop:server:redeem:gold:bars')
AddEventHandler('fw-pawnshop:server:redeem:gold:bars', function()
    local Player = Framework.Functions.GetPlayer(source)
    Player.Functions.AddItem("gold-bar", TotalGoldBars)
    TriggerClientEvent("fw-inventory:client:ItemBox", source, Framework.Shared.Items["gold-bar"], "add")
    TriggerClientEvent('fw-pawnshop:server:reset:smelter', -1)
    TotalGoldBars = 0
end)