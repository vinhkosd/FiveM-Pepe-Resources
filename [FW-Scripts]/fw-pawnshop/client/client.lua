LoggedIn = false

Framework = nil

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(750, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end) 
     Citizen.Wait(150)   
     Framework.Functions.TriggerCallback('fw-pawnshop:server:get:config', function(ConfigData)
      Config = ConfigData
     end)
     LoggedIn = true
    end)
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