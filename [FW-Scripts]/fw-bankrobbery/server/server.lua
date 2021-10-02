local IsBankBeingRobbed = false

Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback("fw-bankrobbery:server:get:status", function(source, cb)
  cb(IsBankBeingRobbed)
end)

Framework.Functions.CreateCallback("fw-bankrobbery:server:get:key:config", function(source, cb)
  cb(Config)
end)

Framework.Functions.CreateCallback('fw-bankrobbery:server:HasItem', function(source, cb, ItemName)
  local Player = Framework.Functions.GetPlayer(source)
  local Item = Player.Functions.GetItemByName(ItemName)
  if Player ~= nil then
     if Item ~= nil then
       cb(true)
     else
       cb(false)
     end
  end
end)

Framework.Functions.CreateCallback('fw-bankrobbery:server:HasLockpickItems', function(source, cb)
  local Player = Framework.Functions.GetPlayer(source)
  local LockpickItem = Player.Functions.GetItemByName('lockpick')
  local ToolkitItem = Player.Functions.GetItemByName('toolkit')
  local AdvancedLockpick = Player.Functions.GetItemByName('advancedlockpick')
  if Player ~= nil then
    if LockpickItem ~= nil and ToolkitItem ~= nil or AdvancedLockpick ~= nil then
      cb(true)
    else
      cb(false)
    end
  end
end)

RegisterServerEvent('fw-bankrobbery:server:set:state')
AddEventHandler('fw-bankrobbery:server:set:state', function(BankId, LockerId, Type, bool)
 Config.BankLocations[BankId]['Lockers'][LockerId][Type] = bool
 TriggerClientEvent('fw-bankrobbery:client:set:state', -1, BankId, LockerId, Type, bool)
end)

RegisterServerEvent('fw-bankrobbery:server:set:open')
AddEventHandler('fw-bankrobbery:server:set:open', function(BankId, bool)
 IsBankBeingRobbed = bool
 Config.BankLocations[BankId]['IsOpened'] = bool
 TriggerClientEvent('fw-bankrobbery:client:set:open', -1, BankId, bool)
 StartRestart(BankId)
end)

RegisterServerEvent('fw-bankrobbery:server:random:reward')
AddEventHandler('fw-bankrobbery:server:random:reward', function(Tier, BankId)
  local Player = Framework.Functions.GetPlayer(source)
  local RandomValue = math.random(1, 110)
  if BankId ~= 6 then
      if RandomValue >= 1 and RandomValue <= 18 then
        if Tier == 2 then
          Player.Functions.AddItem('yellow-card', 1)
          TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['yellow-card'], "add")
        elseif Tier == 3 then
          Player.Functions.AddItem('bank-black', 1)
          TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['bank-black'], "add")
        end
        Player.Functions.AddMoney('cash', math.random(1000, 2500), "Bank Robbery")
      elseif RandomValue >= 22 and RandomValue <= 35 then
        Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(3500, 5000)})
        TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['markedbills'], "add")
      elseif RandomValue >= 40 and RandomValue <= 52 then
        Player.Functions.AddItem('gold-bar', math.random(1,4))
        TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['gold-bar'], "add") 
      elseif RandomValue >= 55 and RandomValue <= 75 then
        Player.Functions.AddItem('gold-necklace', math.random(4,8))
        TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['gold-necklace'], "add") 
      elseif RandomValue >= 76 and RandomValue <= 96 then
        Player.Functions.AddItem('gold-rolex', math.random(4,8))
        TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['gold-rolex'], "add")
      elseif RandomValue == 110 or RandomValue == 97 or RandomValue == 98 or RandomValue == 105 then
        local Info = {quality = 100.0, ammo = 10}
        if Tier == 1 then
          Player.Functions.AddItem('weapon_heavypistol', 1, false, Info)
          TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['weapon_heavypistol'], "add")
        elseif Tier == 2 then
          Player.Functions.AddItem('weapon_snspistol_mk2', 1, false, Info)
          TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['weapon_snspistol_mk2'], "add")
        elseif Tier == 3 then
          Player.Functions.AddItem('pistol-ammo', math.random(2,6))
          TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['pistol-ammo'], "add")
        end
      else
        TriggerClientEvent('Framework:Notify', source, "Je vond niks hier..", "error", 4500)
      end
  else
      if RandomValue >= 1 and RandomValue <= 18 then
        if Tier == 2 then
          Player.Functions.AddItem('yellow-card', 1)
          TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['yellow-card'], "add")
        elseif Tier == 3 then
          Player.Functions.AddItem('bank-black', 1)
          TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['bank-black'], "add")
        end
        Player.Functions.AddMoney('cash', math.random(2500, 3500), "Bank Robbery")
      elseif RandomValue >= 22 and RandomValue <= 36 then
        Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(7500, 8000)})
        TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['markedbills'], "add")
      elseif RandomValue >= 40 and RandomValue <= 55 then
        Player.Functions.AddItem('gold-bar', math.random(1,4))
        TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['gold-bar'], "add") 
      elseif RandomValue >= 62 and RandomValue <= 96 then
        Player.Functions.AddItem('gold-rolex', math.random(4,8))
        TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['gold-rolex'], "add")
      elseif RandomValue == 110 or RandomValue == 97 or RandomValue == 98 or RandomValue == 105 then
        local Info = {quality = 100.0, ammo = 10}
        if Tier == 1 then
          Player.Functions.AddItem('weapon_heavypistol', 1, false, Info)
          TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['weapon_heavypistol'], "add")
        elseif Tier == 2 then
          Player.Functions.AddItem('weapon_vintagepistol', 1, false, Info)
          TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['weapon_vintagepistol'], "add")
        elseif Tier == 3 then
          Player.Functions.AddItem('pistol-ammo', math.random(2,6))
          TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['pistol-ammo'], "add")
        end
      else
        TriggerClientEvent('Framework:Notify', source, "Je vond niks hier..", "error", 4500)
      end
  end
end)

RegisterServerEvent('fw-bankrobbery:server:rob:pacific:money')
AddEventHandler('fw-bankrobbery:server:rob:pacific:money', function()
  local Player = Framework.Functions.GetPlayer(source)
  local RandomValue = math.random(1, 110)
  Player.Functions.AddMoney('cash', math.random(1500, 2000), "Bank Robbery")
  if RandomValue > 15 and  RandomValue < 20 then
     Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(12500, 20000)})
     TriggerClientEvent('fw-inventory:client:ItemBox', source, Framework.Shared.Items['markedbills'], "add")
  end
end)

RegisterServerEvent('fw-bankrobbery:server:pacific:start')
AddEventHandler('fw-bankrobbery:server:pacific:start', function()
  Config.SpecialBanks[1]['Open'] = true
  IsBankBeingRobbed = true
  TriggerClientEvent('fw-bankrobbery:client:pacific:start', -1)
  Citizen.SetTimeout((1000 * 60) * math.random(20,30), function()
    TriggerClientEvent('fw-bankrobbery:client:clear:trollys', -1)
    TriggerClientEvent('fw-doorlock:server:reset:door:looks', -1)
    IsBankBeingRobbed = false
    for k,v in pairs(Config.Trollys) do 
      v['Open-State'] = false
    end
  end)
end)

RegisterServerEvent('fw-bankrobbery:server:set:trolly:state')
AddEventHandler('fw-bankrobbery:server:set:trolly:state', function(TrollyNumber, bool)
 Config.Trollys[TrollyNumber]['Open-State'] = bool
 TriggerClientEvent('fw-bankrobbery:client:set:trolly:state', -1, TrollyNumber, bool)
end)

function StartRestart(BankId)
  Citizen.SetTimeout((1000 * 60) * math.random(20,30), function()
    IsBankBeingRobbed = false
    Config.BankLocations[BankId]['IsOpened'] = false
    TriggerClientEvent('fw-bankrobbery:client:set:open', -1, BankId, false)
    --DOORS reset
    for k, v in pairs(Config.BankLocations[BankId]['DoorId']) do
      TriggerEvent('fw-doorlock:server:updateState', v, true)
    end
    -- Lockers
    for k,v in pairs(Config.BankLocations[BankId]['Lockers']) do
     v['IsBusy'] = false
     v['IsOpend'] = false
    TriggerClientEvent('fw-bankrobbery:client:set:state', -1, BankId, k, 'IsBusy', false)
    TriggerClientEvent('fw-bankrobbery:client:set:state', -1, BankId, k, 'IsOpend', false)
    end
  end)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(4)
    for k, v in pairs(Config.BankLocations) do
      local RandomCard = Config.CardType[math.random(1, #Config.CardType)]
      Config.BankLocations[k]['card-type'] = RandomCard
      TriggerClientEvent('fw-bankrobbery:client:set:cards', -1, k, Config.BankLocations[k]['card-type'])
    end
    Citizen.Wait((1000 * 60) * 60)
  end
end)
-- // Card Types \\ --

Framework.Functions.CreateUseableItem("red-card", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('fw-bankrobbery:client:use:card', source, 'red-card')
    end
end)

Framework.Functions.CreateUseableItem("purple-card", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('fw-bankrobbery:client:use:card', source, 'purple-card')
    end
end)

Framework.Functions.CreateUseableItem("blue-card", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('fw-bankrobbery:client:use:card', source, 'blue-card')
    end
end)

Framework.Functions.CreateUseableItem("black-card", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('fw-bankrobbery:client:use:black-card', source)
    end
end)