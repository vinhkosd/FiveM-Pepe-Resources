Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Commands.Add("refresheye", "Reset het oogje", {}, false, function(source, args)
    TriggerClientEvent('fw-eye:client:refresh', source)
end)

RegisterServerEvent('fw-eye:server:setup:trunk:data')
AddEventHandler('fw-eye:server:setup:trunk:data', function(Plate)
    Config.TrunkData[Plate] = {['Busy'] = false}
    TriggerClientEvent('fw-eye:client:sync:trunk:data', -1, Config.TrunkData)
end)

RegisterServerEvent('fw-eye:server:set:trunk:data')
AddEventHandler('fw-eye:server:set:trunk:data', function(Plate, Bool)
    Config.TrunkData[Plate]['Busy'] = Bool
    TriggerClientEvent('fw-eye:client:sync:trunk:data', -1, Config.TrunkData)
end)
