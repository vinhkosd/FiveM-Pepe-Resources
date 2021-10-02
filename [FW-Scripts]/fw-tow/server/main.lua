Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback('fw-tow:server:get:config', function(source, cb)
    cb(Config)
end)

Framework.Functions.CreateCallback('fw-tow:server:do:bail', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney('cash', Config.BailPrice, 'bail-voertuig') then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('fw-tow:server:add:towed')
AddEventHandler('fw-tow:server:add:towed', function(PaymentAmount)
    local Player = Framework.Functions.GetPlayer(source)
    if Config.JobData[Player.PlayerData.citizenid] ~= nil then
        Config.JobData[Player.PlayerData.citizenid]['Payment'] = Config.JobData[Player.PlayerData.citizenid]['Payment'] + math.ceil(PaymentAmount)
    else
        Config.JobData[Player.PlayerData.citizenid]= {['Payment'] = 0 + math.ceil(PaymentAmount)}
    end
    TriggerClientEvent('fw-tow:client:add:towed', -1, Player.PlayerData.citizenid, math.ceil(PaymentAmount), 'Add')
end)

RegisterServerEvent('fw-tow:server:recieve:payment')
AddEventHandler('fw-tow:server:recieve:payment', function()
    local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.AddMoney('cash', Config.JobData[Player.PlayerData.citizenid]['Payment']) then
      local AmountNetto = Config.JobData[Player.PlayerData.citizenid]['Payment'] + math.random(125, 200)
      TriggerClientEvent('chatMessage', source, "Bergnet Leiding", "warning", "Je hebt je salaris ontvangen van: €"..AmountNetto..", bruto: €"..Config.JobData[Player.PlayerData.citizenid]['Payment'])
      Config.JobData[Player.PlayerData.citizenid]['Payment'] = 0
      TriggerClientEvent('fw-tow:client:add:towed', -1, Player.PlayerData.citizenid, 0, 'Set')
    end
end)

RegisterServerEvent('fw-tow:server:return:bail:fee')
AddEventHandler('fw-tow:server:return:bail:fee', function()
    local Player = Framework.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', Config.BailPrice)
end)
