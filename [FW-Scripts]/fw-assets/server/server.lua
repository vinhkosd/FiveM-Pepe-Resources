Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('fw-assets:server:tackle:player')
AddEventHandler('fw-assets:server:tackle:player', function(playerId)
    TriggerClientEvent("fw-assets:client:get:tackeled", playerId)
end)

RegisterServerEvent('fw-assets:server:display:text')
AddEventHandler('fw-assets:server:display:text', function(Text)
	TriggerClientEvent('fw-assets:client:me:show', -1, Text, source)
end)

RegisterServerEvent('fw-assets:server:drop')
AddEventHandler('fw-assets:server:drop', function()
	if not Framework.Functions.HasPermission(source, 'admin') then
		TriggerEvent("fw-logs:server:SendLog", "anticheat", "Nui Devtools", "red", "**".. GetPlayerName(source).. "** Heeft geprobeerd om de NUIDevtoolt te activeren.")
		DropPlayer(source, '\nHet is niet de bedoeling dat je de devtools opent..')
	end
end)

Framework.Commands.Add("shuff", "Van stoel schuiven", {}, false, function(source, args)
 TriggerClientEvent('fw-assets:client:seat:shuffle', source)
end)

Framework.Commands.Add("me", "Karakter expresie", {}, false, function(source, args)
  local Text = table.concat(args, ' ')
  TriggerClientEvent('fw-assets:client:me:show', -1, Text, source)
end)