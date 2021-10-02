RegisterServerEvent('fw-sound:server:play')
AddEventHandler('fw-sound:server:play', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('fw-sound:client:play', clientNetId, soundFile, soundVolume)
end)

RegisterServerEvent('fw-sound:server:play:source')
AddEventHandler('fw-sound:server:play:source', function(soundFile, soundVolume)
    TriggerClientEvent('fw-sound:client:play', source, soundFile, soundVolume)
end)

RegisterServerEvent('fw-sound:server:play:distance')
AddEventHandler('fw-sound:server:play:distance', function(maxDistance, soundFile, soundVolume)
    TriggerClientEvent('fw-sound:client:play:distance', -1, source, maxDistance, soundFile, soundVolume)
end)