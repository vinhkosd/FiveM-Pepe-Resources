Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback('fw-carwash:server:can:wash', function(source, cb, price)
    local CanWash = false
    local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney("cash", price, "car-wash") then
        CanWash = true
    else 
        CanWash = false
    end
    cb(CanWash)
end)

RegisterServerEvent('fw-carwash:server:set:busy')
AddEventHandler('fw-carwash:server:set:busy', function(CarWashId, bool)
 Config.CarWashLocations[CarWashId]['Busy'] = bool
 TriggerClientEvent('fw-carwash:client:set:busy', -1, CarWashId, bool)
end)

RegisterServerEvent('fw-carwash:server:sync:wash')
AddEventHandler('fw-carwash:server:sync:wash', function(Vehicle)
 TriggerClientEvent('fw-carwash:client:sync:wash', -1, Vehicle)
end)

RegisterServerEvent('fw-carwash:server:sync:water')
AddEventHandler('fw-carwash:server:sync:water', function(WaterId)
 TriggerClientEvent('fw-carwash:client:sync:water', -1, WaterId)
end)

RegisterServerEvent('fw-carwash:server:stop:water')
AddEventHandler('fw-carwash:server:stop:water', function(WaterId)
 TriggerClientEvent('fw-carwash:client:stop:water', -1, WaterId)
end)
