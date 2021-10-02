Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Citizen.CreateThread(function()
    Config.Dealers[1]['Coords'] = {['X'] = 1130.21, ['Y'] = -989.20, ['Z'] = 45.96}
    Config.Dealers[2]['Coords'] = {['X'] = -104.62, ['Y'] = -69.47, ['Z'] = 58.85}
    Config.Dealers[3]['Coords'] = {['X'] = 780.41, ['Y'] = -1296.81, ['Z'] = 361.42}
    Config.Dealers[4]['Coords'] = {['X'] = 482.88, ['Y'] = -2217.19, ['Z'] = 23.94}
end)

Framework.Functions.CreateCallback("fw-dealers:server:get:config", function(source, cb)
    cb(Config.Dealers)
end)

RegisterServerEvent('fw-dealers:server:update:dealer:items')
AddEventHandler('fw-dealers:server:update:dealer:items', function(ItemData, Amount, Dealer)
    Config.Dealers[Dealer]["Products"][ItemData.slot].amount = Config.Dealers[Dealer]["Products"][ItemData.slot].amount - Amount
    TriggerClientEvent('fw-dealers:client:set:dealer:items', -1, ItemData, Amount, Dealer)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        Config.Dealers[2]['Products'][1].amount = Config.Dealers[2]['Products'][1].resetamount
        Config.Dealers[2]['Products'][2].amount = Config.Dealers[2]['Products'][2].resetamount
        Config.Dealers[3]['Products'][1].amount = Config.Dealers[3]['Products'][1].resetamount
        Config.Dealers[3]['Products'][2].amount = Config.Dealers[3]['Products'][2].resetamount
        Config.Dealers[4]['Products'][1].amount = Config.Dealers[4]['Products'][1].resetamount
        Config.Dealers[4]['Products'][2].amount = Config.Dealers[4]['Products'][2].resetamount
        TriggerClientEvent('fw-dealers:client:reset:items', -1)
        Citizen.Wait((1000 * 60) * 120)
    end
end)