Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback("fw-doorlock:server:get:config", function(source, cb)
    cb(Config)
end)

RegisterServerEvent('fw-doorlock:server:change:door:looks')
AddEventHandler('fw-doorlock:server:change:door:looks', function(Door, Type)
 TriggerClientEvent('fw-doorlock:client:change:door:looks', -1, Door, Type)
end)

RegisterServerEvent('fw-doorlock:server:reset:door:looks')
AddEventHandler('fw-doorlock:server:reset:door:looks', function()
 TriggerClientEvent('fw-doorlock:client:reset:door:looks', -1)
end)

RegisterServerEvent('fw-doorlock:server:updateState')
AddEventHandler('fw-doorlock:server:updateState', function(doorID, state)
 Config.Doors[doorID]['Locked'] = state
 TriggerClientEvent('fw-doorlock:client:setState', -1, doorID, state)
end)