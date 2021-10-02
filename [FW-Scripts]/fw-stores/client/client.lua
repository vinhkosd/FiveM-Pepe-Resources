local NearShop = false
local isLoggedIn = false
local CurrentShop = nil

Framework = nil   
 
RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
   TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
   Citizen.Wait(250)
   isLoggedIn = true
 end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            NearShop = false
            for k, v in pairs(Config.Shops) do
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                if Distance < 2.5 then
                    NearShop = true
                    if k ~= CurrentShop then
                        CurrentShop = k
                    end
                end
            end
            if not NearShop then
                Citizen.Wait(1000)
                CurrentShop = nil
            end
        end
    end
end)

RegisterNetEvent('fw-stores:server:open:shop')
AddEventHandler('fw-stores:server:open:shop', function()
  Citizen.SetTimeout(350, function()
      if CurrentShop ~= nil then 
        local Shop = {label = Config.Shops[CurrentShop]['Name'], items = Config.Shops[CurrentShop]['Product'], slots = 30}
        TriggerServerEvent("fw-inventory:server:OpenInventory", "shop", "Itemshop_"..CurrentShop, Shop)
      end
  end)
end)

RegisterNetEvent('fw-stores:client:update:store')
AddEventHandler('fw-stores:client:update:store', function(ItemData, Amount)
    --TriggerServerEvent('fw-stores:server:update:store:items', CurrentShop, ItemData, Amount)
end)

RegisterNetEvent('fw-stores:client:set:store:items')
AddEventHandler('fw-stores:client:set:store:items', function(ItemData, Amount, ShopId)
    Config.Shops[ShopId]["Product"][ItemData.slot].amount = Config.Shops[ShopId]["Product"][ItemData.slot].amount - Amount
end)

RegisterNetEvent('fw-stores:client:open:custom:store')
AddEventHandler('fw-stores:client:open:custom:store', function(ProductName)
    local Shop = {label = ProductName, items = Config.Products[ProductName], slots = 30}
    TriggerServerEvent("fw-inventory:server:OpenInventory", "shop", "custom", Shop)
end)