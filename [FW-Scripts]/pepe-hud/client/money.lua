local cashAmount = 0
local bankAmount = 0

Framework = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(200)
        if Framework == nil then
            TriggerEvent("Framework:getObject", function(obj) Framework = obj end)    
        end
    end
end)

 RegisterNetEvent("hud:client:ShowMoney")
 AddEventHandler("hud:client:ShowMoney", function(type)
     Framework.Functions.GetPlayerData(function(PlayerData)
         CashAmount = PlayerData.money["cash"]
     end)
     TriggerEvent("hud:client:SetMoney")
     SendNUIMessage({
         action = "show",
         cash = cashAmount,
         bank = bankAmount,
         type = type,
     })
 end)

 RegisterNetEvent("pepe-hud:client:money:change")
 AddEventHandler("pepe-hud:client:money:change", function(type, amount, isMinus)
     Framework.Functions.GetPlayerData(function(PlayerData)
         CashAmount = PlayerData.money["cash"]
     end)
      SendNUIMessage({
          action = "update",
          cash = CashAmount,
          amount = amount,
          minus = isMinus,
          type = type,
      })
 end)


RegisterNetEvent("hud:client:SetMoney")
AddEventHandler("hud:client:SetMoney", function()
    Framework.Functions.GetPlayerData(function(PlayerData)
        if PlayerData ~= nil and PlayerData.money ~= nil then
            cashAmount = PlayerData.money["cash"]
            bankAmount = PlayerData.money["bank"]
        end
    end)
    if QBHud.Money.ShowConstant then
        SendNUIMessage({
            action = "open",
            cash = cashAmount,
            bank = bankAmount,
        })
    end
end)

RegisterNetEvent("hud:client:ShowMoney")
AddEventHandler("hud:client:ShowMoney", function(type)
    TriggerEvent("hud:client:SetMoney")
    SendNUIMessage({
        action = "show",
        cash = cashAmount,
        bank = bankAmount,
        type = type,
    })
end)

RegisterNetEvent("hud:client:OnMoneyChange")
AddEventHandler("hud:client:OnMoneyChange", function(type, amount, isMinus)
    Framework.Functions.GetPlayerData(function(PlayerData)
        cashAmount = PlayerData.money["cash"]
        bankAmount = PlayerData.money["bank"]
    end)
    
    if QBHud.Money.ShowConstant then
        SendNUIMessage({
            action = "open",
            cash = cashAmount,
            bank = bankAmount,
        })
    else
        SendNUIMessage({
            action = "update",
            cash = cashAmount,
            bank = bankAmount,
            amount = amount,
            minus = isMinus,
            type = type,
        })
    end
end)