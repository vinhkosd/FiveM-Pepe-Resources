Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback('fw-emergencylights:server:get:config', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('fw-emergencylights:server:setup:first:time')
AddEventHandler('fw-emergencylights:server:setup:first:time', function(Plate)
    Config.ButtonData[Plate] = {
        ['Blue'] = false,
        ['Orange'] = false,
        ['Green'] = false,
        ['Stop'] = false,
        ['Follow'] = false,
        ['Siren'] = false,
        ['Pit'] = false,
    }
    TriggerClientEvent('fw-emergencylights:client:setup:first:time', -1, Plate)
end)

RegisterServerEvent('fw-emergencylights:server:update:button')
AddEventHandler('fw-emergencylights:server:update:button', function(Data, Plate)
    Config.ButtonData[Plate][Data.Type] = Data.State
    TriggerClientEvent('fw-emergencylights:client:update:button', -1, Data, Plate)
end)

RegisterServerEvent('fw-emergencylights:server:toggle:sounds')
AddEventHandler('fw-emergencylights:server:toggle:sounds', function(State)
    TriggerClientEvent('fw-emergencylights:client:toggle:sounds', -1, source, State)
end)

RegisterServerEvent('fw-emergencylights:server:set:sounds:disabled')
AddEventHandler('fw-emergencylights:server:set:sounds:disabled', function()
    TriggerClientEvent('fw-emergencylights:client:set:sounds:disabled', -1, source)
end)