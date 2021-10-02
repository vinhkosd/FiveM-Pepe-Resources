Framework = nil
   
RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
    end) 
end)


RegisterNetEvent('fw-judge:client:toggle')
AddEventHandler('fw-judge:client:toggle', function()
  exports['fw-assets']:AddProp('Tablet')
  exports['fw-assets']:RequestAnimationDict('amb@code_human_in_bus_passenger_idles@female@tablet@base')
  TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
  Citizen.SetTimeout(500, function()
   SetNuiFocus(true, true)
   SendNUIMessage({
       type = "tablet",
   })
  end)
end)

RegisterNetEvent('fw-judge:client:lawyer:add:closest')
AddEventHandler('fw-judge:client:lawyer:add:closest', function()
local Player, Distance = Framework.Functions.GetClosestPlayer()
 if Player ~= -1 and Distance < 1.5 then
  local ServerId = GetPlayerServerId(Player)
  TriggerServerEvent('fw-judge:lawyer:add', ServerId)
 end
end)

RegisterNetEvent("fw-judge:client:show:pass")
AddEventHandler("fw-judge:client:show:pass", function(SourceId, data)
    local SourceCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(SourceId)), false)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, SourceCoords.x, SourceCoords.y, SourceCoords.z, true) < 2.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Pas-ID:</strong> {1} <br><strong>Voornaam:</strong> {2} <br><strong>Achternaam:</strong> {3} <br><strong>BSN:</strong> {4} </div></div>',
            args = {'Advocatenpas', data.id, data.firstname, data.lastname, data.citizenid}
        })
    end
end)

RegisterNUICallback("closetablet", function()
  SetNuiFocus(false, false)
  if exports['fw-assets']:GetPropStatus() then
    exports['fw-assets']:RemoveProp()
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "exit", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
  end
end)