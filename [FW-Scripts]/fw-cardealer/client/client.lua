LoggedIn = false
Framework = nil

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
     Citizen.Wait(250)
     Framework.Functions.TriggerCallback("fw-cardealer:server:get:config", function(ConfigData)
        Config = ConfigData
     end)
     LoggedIn = true
 end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

Citizen.CreateThread(function()
    Citizen.SetTimeout(1250, function()
        TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
        Citizen.Wait(250)
        Framework.Functions.TriggerCallback("fw-cardealer:server:get:config", function(ConfigData)
           Config = ConfigData
        end)
        LoggedIn = true
    end)
end)

-- Code

RegisterNetEvent('fw-cardealer:client:open:tablet')
AddEventHandler('fw-cardealer:client:open:tablet', function()
    Citizen.SetTimeout(1000, function()
        exports['fw-assets']:AddProp('Tablet')
        exports['fw-assets']:RequestAnimationDict('amb@code_human_in_bus_passenger_idles@female@tablet@base')
        TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
        Citizen.Wait(750)
        SetNuiFocus(true, true)
        SendNUIMessage({action = 'OpenTablet'})
    end)
end)

RegisterNUICallback('GetStockVehicles', function(data, cb)
    Framework.Functions.TriggerCallback('fw-cardealer:server:get:storage:cars', function(StockData)
        cb(StockData)
    end)
end)

RegisterNUICallback('Click', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('ErrorSound', function()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback('CloseNui', function()
    SetNuiFocus(false, false)
    exports['fw-assets']:RemoveProp()
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "exit", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
end)

function DrawText3D(x, y, z, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x,y,z, 0)
  DrawText(0.0, 0.0)
  ClearDrawOrigin()
end