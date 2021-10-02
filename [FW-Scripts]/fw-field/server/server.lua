Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('fw-field:server:set:plant:busy')
AddEventHandler('fw-field:server:set:plant:busy', function(PlantId, bool)
    Config.Plants['planten'][PlantId]['IsBezig'] = bool
    TriggerClientEvent('fw-field:client:set:plant:busy', -1, PlantId, bool)
end)

RegisterServerEvent('fw-field:server:set:picked:state')
AddEventHandler('fw-field:server:set:picked:state', function(PlantId, bool)
    Config.Plants['planten'][PlantId]['Geplukt'] = bool
    TriggerClientEvent('fw-field:client:set:picked:state', -1, PlantId, bool)
end)

RegisterServerEvent('fw-field:server:set:dry:busy')
AddEventHandler('fw-field:server:set:dry:busy', function(DryRackId, bool)
    Config.Plants['drogen'][DryRackId]['IsBezig'] = bool
    TriggerClientEvent('fw-field:client:set:dry:busy', -1, DryRackId, bool)
end)

RegisterServerEvent('fw-field:server:set:pack:busy')
AddEventHandler('fw-field:server:set:pack:busy', function(PackerId, bool)
    Config.Plants['verwerk'][PackerId]['IsBezig'] = bool
    TriggerClientEvent('fw-field:client:set:pack:busy', -1, PackerId, bool)
end)

RegisterServerEvent('fw-field:server:add:cash')
AddEventHandler('fw-field:server:add:cash', function()
    local Speler = Framework.Functions.GetPlayer(source)
    local RandomAmount = math.random(10,34)
    Speler.Functions.AddMoney('cash', RandomAmount, "dried-bud-sell")
end)

RegisterServerEvent('fw-field:server:give:tak')
AddEventHandler('fw-field:server:give:tak', function()
    local Speler = Framework.Functions.GetPlayer(source)
    Speler.Functions.AddItem('wet-tak', math.random(2,4))
    TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['wet-tak'], "add")
end)

RegisterServerEvent('fw-field:server:add:item')
AddEventHandler('fw-field:server:add:item', function(Item, Amount)
    local Player = Framework.Functions.GetPlayer(source)
    Player.Functions.AddItem(Item, Amount)
    TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items[Item], "add")
end)

RegisterServerEvent('fw-field:server:remove:item')
AddEventHandler('fw-field:server:remove:item', function(Item, Amount)
    local Player = Framework.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(Item, Amount)
    TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items[Item], "remove")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        for k, v in pairs(Config.Plants['planten']) do
         if Config.Plants['planten'][k]['Geplukt'] then
             Citizen.Wait(30000)
             Config.Plants['planten'][k]['Geplukt'] = false
             TriggerClientEvent('fw-field:client:set:picked:state', -1, k, false)
         end
      end
  end
end)

-- Functions

Framework.Functions.CreateCallback('fw-field:server:GetConfig', function(source, cb)
    cb(Config)
end)

Framework.Functions.CreateCallback('fw-field:server:has:takken', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    local ItemTak = Player.Functions.GetItemByName("wet-tak")
	if ItemTak ~= nil then
        if ItemTak.amount >= 2 then
            cb(true)
		else
            cb(false)
		end
	   else
        cb(false)
	end
end)

Framework.Functions.CreateCallback('fw-field:server:has:nugget', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    local ItemNugget = Player.Functions.GetItemByName("wet-bud")
    local ItemBag = Player.Functions.GetItemByName("plastic-bag")
	if ItemNugget ~= nil and ItemBag ~= nil then
        if ItemNugget.amount >= 2 and ItemBag.amount >= 1 then
            cb(true)
		else
            cb(false)
		end
	   else
        cb(false)
	end
end)