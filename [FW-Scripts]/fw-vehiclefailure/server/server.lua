Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Commands.Add("fix", "Repareer een voertuig", {}, false, function(source, args)
    TriggerClientEvent('fw-vehiclefailure:client:fix:veh', source)
end, "admin")