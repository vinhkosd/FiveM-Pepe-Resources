CurrentWeather = 'EXTRASUNNY'
local lastWeather = CurrentWeather
local baseTime = 0
local timeOffset = 0
local timer = 0
local freezeTime = false
local blackout = false

local disable = false

Framework = nil

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
	 Citizen.Wait(250)
	 TriggerEvent('fw-weathersync:client:EnableSync')
     isLoggedIn = true
 end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

--- Code

RegisterNetEvent('fw-weathersync:client:EnableSync')
AddEventHandler('fw-weathersync:client:EnableSync', function()
	disable = false
    TriggerServerEvent('fw-weathersync:server:RequestStateSync')
	SetRainFxIntensity(-1.0)
end)

RegisterNetEvent('fw-weathersync:client:DisableSync')
AddEventHandler('fw-weathersync:client:DisableSync', function()
	disable = true
	Citizen.CreateThread(function() 
		while disable do
			SetRainFxIntensity(0.0)
			SetWeatherTypePersist('EXTRASUNNY')
			SetWeatherTypeNow('EXTRASUNNY')
			SetWeatherTypeNowPersist('EXTRASUNNY')
			NetworkOverrideClockTime(23, 0, 0)
			Citizen.Wait(5000)
		end
	end)
end)

RegisterNetEvent('fw-weathersync:client:SyncTime')
AddEventHandler('fw-weathersync:client:SyncTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)

RegisterNetEvent('fw-weathersync:client:SyncWeather')
AddEventHandler('fw-weathersync:client:SyncWeather', function(NewWeather, newblackout)
    CurrentWeather = NewWeather
    blackout = newblackout
end)

Citizen.CreateThread(function()
    local hour = 0
    local minute = 0
    while true do
		if not disable then
			local newBaseTime = baseTime
			if GetGameTimer() - 500  > timer then
				newBaseTime = newBaseTime + 0.25
				timer = GetGameTimer()
			end
			if freezeTime then
				timeOffset = timeOffset + baseTime - newBaseTime			
			end
			baseTime = newBaseTime
			hour = math.floor(((baseTime+timeOffset)/60)%24)
			minute = math.floor((baseTime+timeOffset)%60)
			NetworkOverrideClockTime(hour, minute, 0)

			Citizen.Wait(2000)
		else
			Citizen.Wait(1000)
		end
    end
end)

Citizen.CreateThread(function()
    while true do
		if not disable then
			if lastWeather ~= CurrentWeather then
				lastWeather = CurrentWeather
				SetWeatherTypeOverTime(CurrentWeather, 15.0)
				Citizen.Wait(15000)
			end
			Citizen.Wait(100) -- Wait 0 seconds to prevent crashing.
			SetBlackout(blackout)
			ClearOverrideWeather()
			ClearWeatherTypePersist()
			SetWeatherTypePersist(lastWeather)
			SetWeatherTypeNow(lastWeather)
			SetWeatherTypeNowPersist(lastWeather)
			if lastWeather == 'XMAS' then
				SetForceVehicleTrails(true)
				SetForcePedFootstepsTracks(true)
			else
				SetForceVehicleTrails(false)
				SetForcePedFootstepsTracks(false)
			end
		else
			Citizen.Wait(1000)
		end
    end
end)

Citizen.CreateThread(function()
  while true do
 	Citizen.Wait(4)
	  if CurrentWeather == 'XMAS' then
		if IsControlJustPressed(0, 47) then
			CancelEvent()
		end
 	 end
  end
end)