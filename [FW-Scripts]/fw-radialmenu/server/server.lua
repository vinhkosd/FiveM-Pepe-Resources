Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Commands.Add("closeradial", "Sluit je radialmenu waneer die vast zit.", {}, false, function(source, args)
   TriggerClientEvent('fw-radialmenu:client:force:close', source)
end)

RegisterServerEvent('fw-radialmenu:server:open:dispatch')
AddEventHandler('fw-radialmenu:server:open:dispatch', function()
   local src = source
   local Player = Framework.Functions.GetPlayer(src)
   Citizen.SetTimeout(650, function()
      if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) or (Player.PlayerData.job.name == "ambulance" and Player.PlayerData.job.onduty) then
         TriggerClientEvent('fw-alerts:client:open:previous:alert', src, Player.PlayerData.job.name)
     end
   end)
end)

Framework.Functions.CreateCallback('fw-radialmenu:server:HasItem', function(source, cb, itemName)
    local Player = Framework.Functions.GetPlayer(source)
    if Player ~= nil then
      local Item = Player.Functions.GetItemByName(itemName)
      if Item ~= nil then
			  cb(true)
      else
			  cb(false)
      end
	end
end)