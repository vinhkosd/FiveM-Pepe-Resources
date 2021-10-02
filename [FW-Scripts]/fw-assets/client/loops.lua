local entityEnumerator = {
 __gc = function(enum)
 	if enum.destructor and enum.handle then
 		enum.destructor(enum.handle)
 	end
 	enum.destructor = nil
 	enum.handle = nil
 end
}

-- // Loops \\ --

-- ViewCam Set

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if GetFollowPedCamViewMode() == 2 then
                SetFollowPedCamViewMode(4)
                SetFollowVehicleCamViewMode(4)
            end
            Citizen.Wait(175)
        end
    end
end)

-- Map Peds
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
        WaterOverrideSetStrength(1.0)
		SetVehicleDensityMultiplierThisFrame(0.47)
		SetPedDensityMultiplierThisFrame(1.0)
	    SetParkedVehicleDensityMultiplierThisFrame(0.10)
		SetScenarioPedDensityMultiplierThisFrame(0.01, 0.01)
	end
end)

-- Air Control

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
		if LoggedIn then
        	local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        	if DoesEntityExist(Vehicle) and not IsEntityDead(Vehicle) then
        	    local Model = GetEntityModel(Vehicle)
        	    if not IsThisModelABoat(Model) and not IsThisModelAHeli(Model) and not IsThisModelAPlane(Model) and IsEntityInAir(Model) then
        	        DisableControlAction(0, 59)
        	        DisableControlAction(0, 60)
        	    end
        	end
		end
    end
end)

-- Tackle 

Citizen.CreateThread(function()
    while true do 
     Citizen.Wait(5)
      if LoggedIn then
        if not IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetEntitySpeed(GetPlayerPed(-1)) > 2.5 then
            if IsControlJustPressed(1, Config.Keys["LEFTALT"]) then
				local Player, PlayerDist = Framework.Functions.GetClosestPlayer()
				if PlayerDist ~= -1 and PlayerDist < 2 then
					CanTackle = false
					TriggerServerEvent("fw-assets:server:tackle:player", GetPlayerServerId(Player))
					TackleAnim()
				end
            end
        else
            Citizen.Wait(250)
        end
      end
    end
end)

-- Blacklist

Citizen.CreateThread(function()
    while true do
        for _, sctyp in next, Config.BlacklistedScenarios['TYPES'] do
            SetScenarioTypeEnabled(sctyp, false)
        end
        for _, scgrp in next, Config.BlacklistedScenarios['GROUPS'] do
            SetScenarioGroupEnabled(scgrp, false)
        end
		for _, carmdl in next, Config.BlacklistedVehs do
			SetVehicleModelIsSuppressed(carmdl, true)
		end
		Citizen.Wait(10000)
    end
end)

-- Hud Components
Citizen.CreateThread(function()
 while true do
 	HideHudComponentThisFrame(1)
 	HideHudComponentThisFrame(2)
 	HideHudComponentThisFrame(3)
 	HideHudComponentThisFrame(4)
 	HideHudComponentThisFrame(7)
 	HideHudComponentThisFrame(9)
 	HideHudComponentThisFrame(13)
 	HideHudComponentThisFrame(14)
 	HideHudComponentThisFrame(17)
    HideHudComponentThisFrame(19)
    HideHudComponentThisFrame(20)
    HideHudComponentThisFrame(21)
 	HideHudComponentThisFrame(22)
 	DisplayAmmoThisFrame(true)
 	Citizen.Wait(4)
 end
end) 

-- Police Disable
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for i = 1, 12 do
			EnableDispatchService(i, false)
		end
		SetPlayerWantedLevel(PlayerId(), 0, false)
		SetPlayerWantedLevelNow(PlayerId(), false)
		SetPlayerWantedLevelNoDrop(PlayerId(), 0, false)
		SetDispatchCopsForPlayer(PlayerId(), false)
		SetAudioFlag("PoliceScannerDisabled", true)		
	end
end)

-- Disable Vehicle Rewards
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(8)
		DisablePlayerVehicleRewards(PlayerId())
		RemoveVehiclesFromGeneratorsInArea(441.8465 - 500.0, -987.99 - 500.0, 30.68 -500.0, 441.8465 + 500.0, -987.99 + 500.0, 30.68 + 500.0)
	end
end)

-- Stop Melee When Weapon is in hand
Citizen.CreateThread(function()
 while true do
	Citizen.Wait(5)
    local Weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
	 if Weapon ~= GetHashKey("WEAPON_UNARMED") then
	  if IsPedArmed(GetPlayerPed(-1), 6) or IsPlayerFreeAiming(PlayerId()) then
        DisableControlAction(1, 140, true)
        DisableControlAction(1, 141, true)
        DisableControlAction(1, 142, true)
 	 end
 	end
 end
end)

-- Disable Seat Shuff

Citizen.CreateThread(function()
  while true do
 	  Citizen.Wait(4)
  	  if IsPedInAnyVehicle(GetPlayerPed(-1), false) and DisableSeatShuff then
  	     if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), false, 0) == GetPlayerPed(-1) then
  	     	if GetIsTaskActive(GetPlayerPed(-1), 165) then
  	     		SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1)), 0)
  	     	end
  	     end
  	  end
  end
end)

-- Disable Weapon Pickup
Citizen.CreateThread(function()
	while true do    
		Citizen.Wait(1)
		 local pickupList = {`PICKUP_AMMO_BULLET_MP`,`PICKUP_AMMO_FIREWORK`,`PICKUP_AMMO_FLAREGUN`,`PICKUP_AMMO_GRENADELAUNCHER`,`PICKUP_AMMO_GRENADELAUNCHER_MP`,`PICKUP_AMMO_HOMINGLAUNCHER`,`PICKUP_AMMO_MG`,`PICKUP_AMMO_MINIGUN`,`PICKUP_AMMO_MISSILE_MP`,`PICKUP_AMMO_PISTOL`,`PICKUP_AMMO_RIFLE`,`PICKUP_AMMO_RPG`,`PICKUP_AMMO_SHOTGUN`,`PICKUP_AMMO_SMG`,`PICKUP_AMMO_SNIPER`,`PICKUP_ARMOUR_STANDARD`,`PICKUP_CAMERA`,`PICKUP_CUSTOM_SCRIPT`,`PICKUP_GANG_ATTACK_MONEY`,`PICKUP_HEALTH_SNACK`,`PICKUP_HEALTH_STANDARD`,`PICKUP_MONEY_CASE`,`PICKUP_MONEY_DEP_BAG`,`PICKUP_MONEY_MED_BAG`,`PICKUP_MONEY_PAPER_BAG`,`PICKUP_MONEY_PURSE`,`PICKUP_MONEY_SECURITY_CASE`,`PICKUP_MONEY_VARIABLE`,`PICKUP_MONEY_WALLET`,`PICKUP_PARACHUTE`,`PICKUP_PORTABLE_CRATE_FIXED_INCAR`,`PICKUP_PORTABLE_CRATE_UNFIXED`,`PICKUP_PORTABLE_CRATE_UNFIXED_INCAR`,`PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_SMALL`,`PICKUP_PORTABLE_CRATE_UNFIXED_LOW_GLOW`,`PICKUP_PORTABLE_DLC_VEHICLE_PACKAGE`,`PICKUP_PORTABLE_PACKAGE`,`PICKUP_SUBMARINE`,`PICKUP_VEHICLE_ARMOUR_STANDARD`,`PICKUP_VEHICLE_CUSTOM_SCRIPT`,`PICKUP_VEHICLE_CUSTOM_SCRIPT_LOW_GLOW`,`PICKUP_VEHICLE_HEALTH_STANDARD`,`PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW`,`PICKUP_VEHICLE_MONEY_VARIABLE`,`PICKUP_VEHICLE_WEAPON_APPISTOL`,`PICKUP_VEHICLE_WEAPON_ASSAULTSMG`,`PICKUP_VEHICLE_WEAPON_COMBATPISTOL`,`PICKUP_VEHICLE_WEAPON_GRENADE`,`PICKUP_VEHICLE_WEAPON_MICROSMG`,`PICKUP_VEHICLE_WEAPON_MOLOTOV`,`PICKUP_VEHICLE_WEAPON_PISTOL`,`PICKUP_VEHICLE_WEAPON_PISTOL50`,`PICKUP_VEHICLE_WEAPON_SAWNOFF`,`PICKUP_VEHICLE_WEAPON_SMG`,`PICKUP_VEHICLE_WEAPON_SMOKEGRENADE`,`PICKUP_VEHICLE_WEAPON_STICKYBOMB`,`PICKUP_WEAPON_ADVANCEDRIFLE`,`PICKUP_WEAPON_APPISTOL`,`PICKUP_WEAPON_ASSAULTRIFLE`,`PICKUP_WEAPON_ASSAULTSHOTGUN`,`PICKUP_WEAPON_ASSAULTSMG`,`PICKUP_WEAPON_AUTOSHOTGUN`,`PICKUP_WEAPON_BAT`,`PICKUP_WEAPON_BATTLEAXE`,`PICKUP_WEAPON_BOTTLE`,`PICKUP_WEAPON_BULLPUPRIFLE`,`PICKUP_WEAPON_BULLPUPSHOTGUN`,`PICKUP_WEAPON_CARBINERIFLE`,`PICKUP_WEAPON_COMBATMG`,`PICKUP_WEAPON_COMBATPDW`,`PICKUP_WEAPON_COMBATPISTOL`,`PICKUP_WEAPON_COMPACTLAUNCHER`,`PICKUP_WEAPON_COMPACTRIFLE`,`PICKUP_WEAPON_CROWBAR`,`PICKUP_WEAPON_DAGGER`,`PICKUP_WEAPON_DBSHOTGUN`,`PICKUP_WEAPON_FIREWORK`,`PICKUP_WEAPON_FLAREGUN`,`PICKUP_WEAPON_FLASHLIGHT`,`PICKUP_WEAPON_GRENADE`,`PICKUP_WEAPON_GRENADELAUNCHER`,`PICKUP_WEAPON_GUSENBERG`,`PICKUP_WEAPON_GOLFCLUB`,`PICKUP_WEAPON_HAMMER`,`PICKUP_WEAPON_HATCHET`,`PICKUP_WEAPON_HEAVYPISTOL`,`PICKUP_WEAPON_HEAVYSHOTGUN`,`PICKUP_WEAPON_HEAVYSNIPER`,`PICKUP_WEAPON_HOMINGLAUNCHER`,`PICKUP_WEAPON_KNIFE`,`PICKUP_WEAPON_KNUCKLE`,`PICKUP_WEAPON_MACHETE`,`PICKUP_WEAPON_MACHINEPISTOL`,`PICKUP_WEAPON_MARKSMANPISTOL`,`PICKUP_WEAPON_MARKSMANRIFLE`,`PICKUP_WEAPON_MG`,`PICKUP_WEAPON_MICROSMG`,`PICKUP_WEAPON_MINIGUN`,`PICKUP_WEAPON_MINISMG`,`PICKUP_WEAPON_MOLOTOV`,`PICKUP_WEAPON_MUSKET`,`PICKUP_WEAPON_NIGHTSTICK`,`PICKUP_WEAPON_PETROLCAN`,`PICKUP_WEAPON_PIPEBOMB`,`PICKUP_WEAPON_PISTOL`,`PICKUP_WEAPON_PISTOL50`,`PICKUP_WEAPON_POOLCUE`,`PICKUP_WEAPON_PROXMINE`,`PICKUP_WEAPON_PUMPSHOTGUN`,`PICKUP_WEAPON_RAILGUN`,`PICKUP_WEAPON_REVOLVER`,`PICKUP_WEAPON_RPG`,`PICKUP_WEAPON_SAWNOFFSHOTGUN`,`PICKUP_WEAPON_SMG`,`PICKUP_WEAPON_SMOKEGRENADE`,`PICKUP_WEAPON_SNIPERRIFLE`,`PICKUP_WEAPON_SNSPISTOL`,`PICKUP_WEAPON_SPECIALCARBINE`,`PICKUP_WEAPON_STICKYBOMB`,`PICKUP_WEAPON_STUNGUN`,`PICKUP_WEAPON_SWITCHBLADE`,`PICKUP_WEAPON_VINTAGEPISTOL`,`PICKUP_WEAPON_WRENCH`}
		 local pedPos = GetEntityCoords(GetPlayerPed(-1), false)
		 for a = 1, #pickupList do
			 if IsPickupWithinRadius(pickupList[a], pedPos.x, pedPos.y, pedPos.z, 200.0) then
				 RemoveAllPickupsOfType(pickupList[a])
			 else
			  Citizen.Wait(5)
			 end
		 end
		Citizen.Wait(3)
	end
end)

-- Discord 
Citizen.CreateThread(function()
 while true do
  local id = GetPlayerServerId(PlayerId())
  SetDiscordAppId(Config.DiscordSettings['AppId'])
  SetDiscordRichPresenceAsset('main')
  SetDiscordRichPresenceAssetText(Config.DiscordSettings['Text'])
  SetDiscordRichPresenceAssetSmall('main')
  SetDiscordRichPresenceAssetSmallText('Server ID: '..id)
  Citizen.Wait(12 * 1000)
 end
end)

Citizen.CreateThread(function()
  SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_HILLBILLY"), GetHashKey('PLAYER'))
  SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_BALLAS"), GetHashKey('PLAYER'))
  SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MEXICAN"), GetHashKey('PLAYER'))
  SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_FAMILY"), GetHashKey('PLAYER'))
  SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MARABUNTE"), GetHashKey('PLAYER'))
  SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_SALVA"), GetHashKey('PLAYER'))
  SetRelationshipBetweenGroups(1, GetHashKey("GANG_1"), GetHashKey('PLAYER'))
  SetRelationshipBetweenGroups(1, GetHashKey("GANG_2"), GetHashKey('PLAYER'))
  SetRelationshipBetweenGroups(1, GetHashKey("GANG_9"), GetHashKey('PLAYER'))
  SetRelationshipBetweenGroups(1, GetHashKey("GANG_10"), GetHashKey('PLAYER'))
  SetRelationshipBetweenGroups(1, GetHashKey("FIREMAN"), GetHashKey('PLAYER'))
  SetRelationshipBetweenGroups(1, GetHashKey("MEDIC"), GetHashKey('PLAYER'))
  SetRelationshipBetweenGroups(1, GetHashKey("COP"), GetHashKey('PLAYER'))
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
        for k, v in pairs(Config.RemoveObjects) do
            local Entity = GetClosestObjectOfType(Config.RemoveObjects[k]['X'], Config.RemoveObjects[k]['Y'], Config.RemoveObjects[k]['Z'], 2.0, GetHashKey(Config.RemoveObjects[k]['Model']), false, false, false)
			SetEntityAsMissionEntity(Entity, 1, 1)
            DeleteObject(Entity)
			SetEntityAsNoLongerNeeded(Entity)
        end
        Citizen.Wait(5000)
    end
end)

-- Remove Blacklist Vehs
Citizen.CreateThread(function()
	while true do
		for veh in EnumerateVehicles() do
			if Config.BlacklistedVehs[GetEntityModel(veh)] then
				DeleteEntity(veh)
			end
		end
        Citizen.Wait(250)
	end
end)

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(5)
	for ped in EnumeratePeds() do
		SetPedDropsWeaponsWhenDead(ped, false)
		if Config.BlacklistedPeds[GetEntityModel(ped)] then
			DeleteEntity(ped)
			SetPedModelIsSuppressed(GetEntityModel(ped), true)
			SetPedModelIsSuppressed(ped, true)
		end
	end
	Citizen.Wait(500)
  end
end)

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
 return coroutine.wrap(function()
 	local iter, id = initFunc()
 	if not id or id == 0 then
 		disposeFunc(iter)
 		return
 	end
 	local enum = {handle = iter, destructor = disposeFunc}
 	setmetatable(enum, entityEnumerator)
 	local next = true
 	repeat
 	coroutine.yield(id)
 	next, id = moveFunc(iter)
 	until not next
 	enum.destructor, enum.handle = nil, nil
 	disposeFunc(iter)
 end)
end