local LoggedIn = false
local CurrentDealer = nil

Framework = nil

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(450, function()
  TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
  Citizen.Wait(250)
  Framework.Functions.TriggerCallback("fw-dealers:server:get:config", function(config)
    Config.Dealers = config
  end)
  LoggedIn = true
 end)
end)

-- Code

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(4)
      if LoggedIn then
        NearDealer = false
         for k, v in pairs(Config.Dealers) do 
          local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
          local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
             if Distance < 2.0 then 
                NearDealer = true
			          DrawMarker(2, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                CurrentDealer = k
             end
         end
         if not NearDealer then
            Citizen.Wait(2500)
            CurrentDealer = nil
         end
      end
    end
end)

RegisterNetEvent('fw-dealers:client:open:dealer')
AddEventHandler('fw-dealers:client:open:dealer', function()
    Citizen.SetTimeout(350, function()
        SetupDealerSerials()
        if CurrentDealer ~= nil then 
          local Shop = {label = Config.Dealers[CurrentDealer]['Name'], items = Config.Dealers[CurrentDealer]['Products'], slots = 30}
          TriggerServerEvent("fw-inventory:server:OpenInventory", "shop", "Dealer_"..CurrentDealer, Shop)
        end
    end)
end)

RegisterNetEvent('fw-dealers:client:update:dealer:items')
AddEventHandler('fw-dealers:client:update:dealer:items', function(ItemData, Amount)
    TriggerServerEvent('fw-dealers:server:update:dealer:items', ItemData, Amount, CurrentDealer)
end)

RegisterNetEvent('fw-dealers:client:set:dealer:items')
AddEventHandler('fw-dealers:client:set:dealer:items', function(ItemData, Amount, Dealer)
    Config.Dealers[Dealer]["Products"][ItemData.slot].amount = Config.Dealers[Dealer]["Products"][ItemData.slot].amount - Amount
end)

RegisterNetEvent('fw-dealers:client:reset:items')
AddEventHandler('fw-dealers:client:reset:items', function()
  Config.Dealers[2]['Products'][1].amount = Config.Dealers[2]['Products'][1].resetamount
  Config.Dealers[2]['Products'][2].amount = Config.Dealers[2]['Products'][2].resetamount
  Config.Dealers[3]['Products'][1].amount = Config.Dealers[3]['Products'][1].resetamount
  Config.Dealers[3]['Products'][2].amount = Config.Dealers[3]['Products'][2].resetamount
  Config.Dealers[4]['Products'][1].amount = Config.Dealers[4]['Products'][1].resetamount
  Config.Dealers[4]['Products'][2].amount = Config.Dealers[4]['Products'][2].resetamount
end)

function CanOpenDealerShop()
    if CurrentDealer ~= nil then
        return true
    end
end

function SetupDealerSerials()
    Config.Dealers[4]["Products"][1].info.serie = Config.RandomStr(2) .. math.random(10,99)..Config.RandomStr(3)..math.random(100,999).. Config.RandomStr(2) ..math.random(1,9)
    Config.Dealers[4]["Products"][2].info.serie = Config.RandomStr(2) .. math.random(10,99)..Config.RandomStr(3)..math.random(100,999).. Config.RandomStr(2) ..math.random(1,9)
end