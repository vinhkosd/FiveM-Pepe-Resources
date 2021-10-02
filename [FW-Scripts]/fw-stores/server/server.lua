Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback('fw-stores:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('fw-stores:server:update:store:items')
AddEventHandler('fw-stores:server:update:store:items', function(Shop, ItemData, Amount)
    Config.Shops[Shop]["Product"][ItemData.slot].amount = Config.Shops[Shop]["Product"][ItemData.slot].amount - Amount
    TriggerClientEvent('fw-stores:client:set:store:items', -1, ItemData, Amount, Shop)
end)