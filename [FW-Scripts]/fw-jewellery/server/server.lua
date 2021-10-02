local IsCooldownActive = false
Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback('fw-jewellery:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('fw-jewellery:server:set:cooldown')
AddEventHandler('fw-jewellery:server:set:cooldown', function(bool)
    Config.Cooldown = bool
    TriggerClientEvent('fw-jewellery:client:set:cooldown', -1, bool)
end)

RegisterServerEvent('fw-jewellery:server:set:vitrine:isopen')
AddEventHandler('fw-jewellery:server:set:vitrine:isopen', function(CaseId, bool)
    Config.Vitrines[CaseId]["IsOpen"] = bool
    TriggerClientEvent('fw-jewellery:client:set:vitrine:isopen', -1, CaseId, bool)
end)

RegisterServerEvent('fw-jewellery:server:set:vitrine:busy')
AddEventHandler('fw-jewellery:server:set:vitrine:busy', function(CaseId, bool)
    Config.Vitrines[CaseId]["IsBusy"] = bool
    TriggerClientEvent('fw-jewellery:client:set:vitrine:busy', -1, CaseId, bool)
end)

RegisterServerEvent('fw-jewellery:server:start:reset')
AddEventHandler('fw-jewellery:server:start:reset', function()
    if not IsCooldownActive then
        IsCooldownActive = true
        Citizen.SetTimeout(Config.TimeOut, function()
            for k,v in pairs(Config.Vitrines) do
                Config.Vitrines[k]["IsOpen"] = false
                Config.Vitrines[k]["IsBusy"] = false
            end
            TriggerEvent('fw-jewellery:server:set:cooldown', false)
            TriggerEvent('fw-doorlock:server:updateState', 28, true)
            IsCooldownActive = false
        end)
    end
end)

RegisterServerEvent('fw-jewellery:vitrine:reward')
AddEventHandler('fw-jewellery:vitrine:reward', function()
    local Player = Framework.Functions.GetPlayer(source)
    local RandomValue = math.random(1,100)
    if RandomValue <= 25 then
     Player.Functions.AddItem('gold-rolex', math.random(5,9))
     TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['gold-rolex'], "add")
    elseif RandomValue >= 26 and RandomValue <= 45 then
     Player.Functions.AddItem('gold-necklace', math.random(5,9))
     TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['gold-necklace'], "add")
    elseif RandomValue >= 46 and RandomValue <= 69 then
     Player.Functions.AddItem('diamond-ring', math.random(5,9))
     TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['diamond-ring'], "add")
    elseif RandomValue >= 90 and RandomValue <= 98 then
      if math.random(1,2) == 1 then
       Player.Functions.AddItem('diamond-blue', math.random(1,2))
       TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['diamond-blue'], "add")
      else
       Player.Functions.AddItem('diamond-red', math.random(1,2))
       TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['diamond-red'], "add")
      end
    else
      Player.Functions.AddItem('gold-necklace', math.random(8))
      TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['gold-necklace'], "add")
    end
end)

Framework.Functions.CreateUseableItem("yellow-card", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('fw-jewellery:client:use:card', source, 'yellow-card')
    end
end)