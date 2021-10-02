Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback('fw-materials:server:is:vehicle:owned', function(source, cb, plate)
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('fw-materials:server:get:reward')
AddEventHandler('fw-materials:server:get:reward', function()
    local Player = Framework.Functions.GetPlayer(source)
    local RandomValue = math.random(1, 100)
    local RandomItems = Config.BinItems[math.random(#Config.BinItems)]
    if RandomValue <= 55 then
     Player.Functions.AddItem(RandomItems, math.random(8, 20))
     TriggerClientEvent('fw-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items[RandomItems], 'add')
    elseif RandomValue >= 87 and RandomValue <= 89 then
        local SubValue = math.random(1, 3)
        if SubValue == 1 then
            Player.Functions.AddItem('knife-part-1', 1)
            TriggerClientEvent('fw-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['knife-part-1'], 'add')
        elseif SubValue == 2 then
            Player.Functions.AddItem('switch-part-1', 1)
            TriggerClientEvent('fw-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['switch-part-1'], 'add')
        else
            Player.Functions.AddItem('rifle-clip', 1)
            TriggerClientEvent('fw-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['rifle-clip'], 'add')
        end
    else
        TriggerClientEvent('Framework:Notify', Player.PlayerData.source, 'Je vond niks..', 'error')
    end
end)

RegisterServerEvent('fw-materials:server:recycle:reward')
AddEventHandler('fw-materials:server:recycle:reward', function()
  local Player = Framework.Functions.GetPlayer(source)
  for i = 1, math.random(2, 5), 1 do
      local Items = Config.CarItems[math.random(1, #Config.CarItems)]
      local RandomNum = math.random(10, 15)
      Player.Functions.AddItem(Items, RandomNum)
      TriggerClientEvent('fw-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items[Items], 'add')
      Citizen.Wait(500)
  end
  if math.random(1, 100) <= 20 then
    Player.Functions.AddItem('rubber', math.random(20, 30))
    TriggerClientEvent('fw-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['rubber'], 'add')
  end
end)

RegisterServerEvent('fw-materials:server:scrap:reward')
AddEventHandler('fw-materials:server:scrap:reward', function()
  local Player = Framework.Functions.GetPlayer(source)
  for i = 1, math.random(4, 8), 1 do
      local Items = Config.CarItems[math.random(1, #Config.CarItems)]
      local RandomNum = math.random(60, 95)
      Player.Functions.AddItem(Items, RandomNum)
      TriggerClientEvent('fw-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items[Items], 'add')
      Citizen.Wait(500)
  end
  if math.random(1, 100) <= 35 then
    Player.Functions.AddItem('rubber', math.random(25, 55))
    TriggerClientEvent('fw-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['rubber'], 'add')
  end
end)