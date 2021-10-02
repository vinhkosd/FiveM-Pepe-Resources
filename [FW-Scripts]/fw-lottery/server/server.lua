Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateUseableItem("lotto-card", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
		local RandomNum = math.random(1,150)
		local Prijs = 0
		if RandomNum <= 10 then
			Prijs = 400
		elseif RandomNum >= 139 and RandomNum <= 141 then
			Prijs = 200
		elseif RandomNum >= 115 and RandomNum <= 119 then
			Prijs = 2000
		elseif RandomNum >= 71 and RandomNum <= 76 then
			Prijs = 1000
		elseif RandomNum >= 43 and RandomNum <= 51 then
			Prijs = 100
		elseif RandomNum == 56 then
			Prijs = 20000
		else
			Prijs = 0
		end
		if Prijs ~= 0 then
			local info = {
				card = Prijs
			}
			Player.Functions.AddItem("used-card", 1, false, info)
		end
		TriggerClientEvent("fw-lottery:client:open:card", source, math.random(11,99), Prijs) 
    end
end)

RegisterServerEvent('fw-lottery:server:sell:card')
AddEventHandler('fw-lottery:server:sell:card', function()
    local Player = Framework.Functions.GetPlayer(source)
	local Item = Player.Functions.GetItemByName('used-card')
	if Item ~= nil then
		local WorthAmount = Item.info.card
		Player.Functions.RemoveItem('used-card', 1)
		Player.Functions.AddMoney('cash', WorthAmount, "used-card")
    	TriggerClientEvent('Framework:Notify', source, 'Je hebt je kraskaart met een waarde van €' ..WorthAmount.. ' ingeleverd.', 'success')
	else
		TriggerClientEvent('Framework:Notify', source, 'Je hebt geen gekraste kraskaarten...', 'error')
	end
end)
