-- // Register Player Data in client \\ --
RegisterNetEvent('Framework:Player:SetPlayerData')
AddEventHandler('Framework:Player:SetPlayerData', function(val)
	Framework.PlayerData = val
end)

RegisterNetEvent('Framework:Player:UpdatePlayerData')
AddEventHandler('Framework:Player:UpdatePlayerData', function()
	local data = {}
	data.position = Framework.Functions.GetCoords(GetPlayerPed(-1))
	TriggerServerEvent('Framework:UpdatePlayer', data)
end)

RegisterNetEvent('Framework:Player:Salary')
AddEventHandler('Framework:Player:Salary', function()
	TriggerServerEvent('Framework:Salary')
end)

-- // Framework Command Events \\ --

RegisterNetEvent('Framework:Command:TeleportToPlayer')
AddEventHandler('Framework:Command:TeleportToPlayer', function(othersource)
	local coords = Framework.Functions.GetCoords(GetPlayerPed(GetPlayerFromServerId(othersource)))
	local entity = GetPlayerPed(-1)
	if IsPedInAnyVehicle(entity, false) then
		entity = GetVehiclePedIsUsing(entity)
	end
	SetEntityCoords(entity, coords.x, coords.y, coords.z)
	SetEntityHeading(entity, coords.a)
end)

RegisterNetEvent('Framework:Command:TeleportToCoords')
AddEventHandler('Framework:Command:TeleportToCoords', function(x, y, z)
	local success = false
	local cx = ToFloat(x)
	local cy = ToFloat(y)
	local cz = z
	local entity = GetPlayerPed(-1)
	if IsPedInAnyVehicle(entity, false) then
		entity = GetVehiclePedIsUsing(entity)
	end

	DoScreenFadeOut(250)
	while IsScreenFadedOut() do
		Citizen.Wait(250)
	end

	local groundFound = false
	local yaw = GetEntityHeading(entity)
	
	for i = 0, 1000, 1 do
		SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
		SetEntityRotation(entity, 0, 0, 0, 0 ,0)
		SetEntityHeading(entity, yaw)
		SetGameplayCamRelativeHeading(0)
		Citizen.Wait(0)
		--groundFound = true
		if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then --GetGroundZFor3dCoord(cx, cy, i, 0, 0) GetGroundZFor_3dCoord(cx, cy, i)
			cz = ToFloat(i)
			groundFound = true
			break
		end
	end
	if not groundFound then
		cz = -300.0
	end
	-- SetEntityCoords(entity, x, y, z)
	SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
	SetGameplayCamRelativeHeading(0)
	if IsPedSittingInAnyVehicle(PlayerPedId()) then
		if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
			SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
		end
	end
	DoScreenFadeIn(250)
end)

RegisterNetEvent('Framework:Command:SpawnVehicle')
AddEventHandler('Framework:Command:SpawnVehicle', function(model)
	Framework.Functions.SpawnVehicle(model, function(vehicle)
	 TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
	 exports['fw-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(vehicle), true)
	 Citizen.Wait(100)
	 exports['fw-fuel']:SetFuelLevel(vehicle, GetVehicleNumberPlateText(vehicle), 100, true)
	 Framework.Functions.Notify('Spawn xe thành công!', 'success')
	end, nil, true, true)
end)

RegisterNetEvent('Framework:Command:DeleteVehicle')
AddEventHandler('Framework:Command:DeleteVehicle', function()
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		Framework.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	else
		local vehicle = Framework.Functions.GetClosestVehicle()
		Framework.Functions.DeleteVehicle(vehicle)
	end
	Framework.Functions.Notify('Xóa xe thành công!', 'error')
end)

RegisterNetEvent('Framework:Command:Revive')
AddEventHandler('Framework:Command:Revive', function()
	local coords = Framework.Functions.GetCoords(GetPlayerPed(-1))
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z+0.2, coords.a, true, false)
	SetPlayerInvincible(GetPlayerPed(-1), false)
	ClearPedBloodDamage(GetPlayerPed(-1))
end)

RegisterNetEvent('Framework:Command:GoToMarker')
AddEventHandler('Framework:Command:GoToMarker', function()
	Citizen.CreateThread(function()
		local entity = PlayerPedId()
		if IsPedInAnyVehicle(entity, false) then
			entity = GetVehiclePedIsUsing(entity)
		end
		local success = false
		local blipFound = false
		local blipIterator = GetBlipInfoIdIterator()
		local blip = GetFirstBlipInfoId(8)

		while DoesBlipExist(blip) do
			if GetBlipInfoIdType(blip) == 4 then
				cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector())) --GetBlipInfoIdCoord(blip)
				blipFound = true
				break
			end
			blip = GetNextBlipInfoId(blipIterator)
		end

		if blipFound then
			DoScreenFadeOut(250)
			while IsScreenFadedOut() do
				Citizen.Wait(250)
			end
			local groundFound = false
			local yaw = GetEntityHeading(entity)
			
			for i = 0, 1000, 1 do
				SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
				SetEntityRotation(entity, 0, 0, 0, 0 ,0)
				SetEntityHeading(entity, yaw)
				SetGameplayCamRelativeHeading(0)
				Citizen.Wait(0)
				--groundFound = true
				if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then --GetGroundZFor3dCoord(cx, cy, i, 0, 0) GetGroundZFor_3dCoord(cx, cy, i)
					cz = ToFloat(i)
					groundFound = true
					break
				end
			end
			if not groundFound then
				cz = -300.0
			end
			success = true
		end

		if success then
			SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
			SetGameplayCamRelativeHeading(0)
			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
					SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
				end
			end
			DoScreenFadeIn(250)
		end
	end)
end)

-- Other stuff
RegisterNetEvent('Framework:Client:LocalOutOfCharacter')
AddEventHandler('Framework:Client:LocalOutOfCharacter', function(playerId, playerName, message)
	local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 20.0) then
		TriggerEvent("chatMessage", "OOC | " .. playerName, "normal", message)
    end
end)

RegisterNetEvent('Framework:Notify')
AddEventHandler('Framework:Notify', function(text, type, length)
	Framework.Functions.Notify(text, type, length)
end)

RegisterNetEvent('fw-core:client:closenui')
AddEventHandler('fw-core:client:closenui', function()
	SetNuiFocus(false, false)
end)

RegisterNetEvent('fw-core:client:opennui')
AddEventHandler('fw-core:client:opennui', function()
	SetNuiFocus(true, true)
end)

RegisterNetEvent('Framework:Client:TriggerCallback')
AddEventHandler('Framework:Client:TriggerCallback', function(name, ...)
	if Framework.ServerCallbacks[name] ~= nil then
		Framework.ServerCallbacks[name](...)
		Framework.ServerCallbacks[name] = nil
	end
end)

RegisterNetEvent("Framework:Client:UseItem")
AddEventHandler('Framework:Client:UseItem', function(item)
	TriggerServerEvent("Framework:Server:UseItem", item)
end)