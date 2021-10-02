Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if NetworkIsSessionStarted() then
			Citizen.Wait(10)
			TriggerServerEvent('Framework:PlayerJoined')
			return
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if isLoggedIn then
			Citizen.Wait((1000 * 60) * 7)
			TriggerEvent("Framework:Player:UpdatePlayerData")
		else
			Citizen.Wait(5000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if isLoggedIn then
			Citizen.Wait((1000 * 60) * 10)
			TriggerEvent("Framework:Player:Salary")
		else
			Citizen.Wait(5000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if isLoggedIn then
			Citizen.Wait(30000)
			local position = Framework.Functions.GetCoords(GetPlayerPed(-1))
			TriggerServerEvent('Framework:UpdatePlayerPosition', position)
		else
			Citizen.Wait(5000)
		end
	end
end)

-- // Food Enz \\ --
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(math.random(3000, 5000))
		if isLoggedIn then
			if Framework.Functions.GetPlayerData().metadata["hunger"] <= 1 or Framework.Functions.GetPlayerData().metadata["thirst"] <= 1 then
				if not Framework.Functions.GetPlayerData().metadata["isdead"] then
				 local CurrentHealth = GetEntityHealth(GetPlayerPed(-1))
				 SetEntityHealth(GetPlayerPed(-1), CurrentHealth - math.random(5, 10))
				end
			end
		end
	end
end)