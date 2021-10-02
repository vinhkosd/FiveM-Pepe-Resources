Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)



Framework.Functions.CreateCallback('fw-fishing:server:can:pay', function(source, cb, price)
    local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney("cash", price, "boat-price") then
        cb(true)
    else 
        cb(false)
    end
end)

Framework.Functions.CreateUseableItem("fishrod", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('fw-fishing:client:use:fishingrod', source)
    end
end)

RegisterServerEvent('fw-fishing:server:fish:reward')
AddEventHandler('fw-fishing:server:fish:reward', function()
    local Player = Framework.Functions.GetPlayer(source)
    local RandomValue = math.random(1, 1000)
    if RandomValue >= 100 and RandomValue < 650 then
        local SubValue = math.random(1,3)
        if SubValue == 1 then
            Player.Functions.AddItem('fish-1', 1)
            TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['fish-1'], "add") 
        elseif SubValue == 2 then
            Player.Functions.AddItem('fish-2', 1)
            TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['fish-2'], "add") 
        else
            Player.Functions.AddItem('fish-3', 1)
            TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['fish-3'], "add") 
        end
    elseif RandomValue >= 700 and RandomValue < 820 then
        local SubValue = math.random(1,2)
        if SubValue == 1 then
            Player.Functions.AddItem('shoe', 1)
            TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['shoe'], "add")  
        else
            Player.Functions.AddItem('plasticbag', 1)
            TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['plasticbag'], "add") 
        end
    else
        TriggerClientEvent('Framework:Notify', source, "Er zat niks aan je haak..", "error")
    end
end)

RegisterServerEvent('fw-fishing:server:repay:bail')
AddEventHandler('fw-fishing:server:repay:bail', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', 500, 'bail-repay')
end)

RegisterServerEvent('fw-fishing:server:sell:items')
AddEventHandler('fw-fishing:server:sell:items', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    for k, v in pairs(Config.SellItems) do
        local Item = Player.Functions.GetItemByName(k)
        if Item ~= nil then
          if Item.amount > 0 then
              for i = 1, Item.amount do
                  Player.Functions.RemoveItem(Item.name, 1)
                  TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items[Item.name], "remove")
                  if v['Type'] == 'item' then
                      Player.Functions.AddItem(v['Item'], v['Amount'])
                  else
                      Player.Functions.AddMoney('cash', v['Amount'], 'sold-fish')
                  end
                  Citizen.Wait(500)
              end
          end
        end
    end
end)