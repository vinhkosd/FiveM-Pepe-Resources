local AlertNumberPolice, AlertNumberAmbulance = 0, 0

Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Commands.Add("dispatch", "Open dispatch log", {}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) or (Player.PlayerData.job.name == "ambulance" and Player.PlayerData.job.onduty) then
        TriggerClientEvent('fw-alerts:client:open:previous:alert', source, Player.PlayerData.job.name)
    end
end)

RegisterServerEvent('fw-alerts:server:send:alert')
AddEventHandler('fw-alerts:server:send:alert', function(data, forBoth)
    forBoth = forBoth ~= nil and forBoth or false
    TriggerClientEvent('fw-alerts:client:send:alert', -1, data, forBoth)
end)