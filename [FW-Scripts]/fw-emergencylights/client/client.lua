local Framework = nil
local LoggedIn = false

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
     Citizen.Wait(350)
     Framework.Functions.TriggerCallback("fw-emergencylights:server:get:config", function(config)
        Config = config
     end)
     LoggedIn = true
 end)
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsControlJustPressed(0, 36) then
               if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) == 18 then
                   if not Config.UiOpend then
                       Config.UiOpend = true
                       SendNUIMessage({
                           action = 'open',
                           buttondata = Config.ButtonData[GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)))],
                           isunmarked = IsVehicleUnmarked(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1))))
                       })
                       SetNuiFocus(true, true)
                       SetNuiFocusKeepInput(true, true)
                       Citizen.InvokeNative(0xFC695459D4D0E219, 0.5, 0.95)
                       TriggerServerEvent('fw-emergencylights:server:set:sounds:disabled')
                       SetVehicleAutoRepairDisabled(GetVehiclePedIsIn(GetPlayerPed(-1)), true)
                   end
               end
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if Config.UiOpend then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 289, true)
            DisableControlAction(0, 288, true)
            DisableControlAction(0, 346, true)
        else
            Citizen.Wait(250)
        end
    end
end)

-- Events --

RegisterNetEvent('fw-emergencylights:client:setup:first:time')
AddEventHandler('fw-emergencylights:client:setup:first:time', function(Plate)
    Config.ButtonData[Plate] = {
        ['Blue'] = false,
        ['Orange'] = false,
        ['Green'] = false,
        ['Stop'] = false,
        ['Follow'] = false,
        ['Siren'] = false,
        ['Pit'] = false,
    }
end)

RegisterNetEvent('fw-emergencylights:client:update:button')
AddEventHandler('fw-emergencylights:client:update:button', function(Data, Plate)
    Config.ButtonData[Plate][Data.Type] = Data.State
end)

RegisterNetEvent('fw-emergencylights:client:toggle:sounds')
AddEventHandler('fw-emergencylights:client:toggle:sounds', function(Sender, State)
    local SelfPed = GetPlayerPed(GetPlayerFromServerId(Sender))
    local Vehicle = GetVehiclePedIsIn(SelfPed)
    local ModelName = GetEntityModel(Vehicle)
    ToggleVehicleSirens(Vehicle, ModelName, GetVehicleNumberPlateText(Vehicle), State)
    ToggleMuteDefaultSiren(Vehicle, true)
end)

RegisterNetEvent('fw-emergencylights:client:set:sounds:disabled')
AddEventHandler('fw-emergencylights:client:set:sounds:disabled', function(Sender)
    local SelfPed = GetPlayerPed(GetPlayerFromServerId(Sender))
    local Vehicle = GetVehiclePedIsIn(SelfPed)
    ToggleMuteDefaultSiren(Vehicle, true)
end)

-- Functions --

function ToggleMuteDefaultSiren(Vehicle, Toggle)
	if DoesEntityExist(Vehicle) and not IsEntityDead(Vehicle) then
		DisableVehicleImpactExplosionActivation(Vehicle, Toggle)
	end
end

function ToggleVehicleSirens(Vehicle, Model, Plate, State)
    if Config.SirenData[Model] ~= nil then
        if State then
           Config.EmergencyData[Plate] = {['SoundId'] = GetSoundId()}
           PlaySoundFromEntity(Config.SirenData[Model]['SoundId'], Config.SirenData[Model]['SirenSound'], Vehicle, 0, 0, 0)
        else
            Config.SirenData[Model]['SoundId'] = nil
            StopSound(Config.SirenData[Model]['SoundId'])
            ReleaseSoundId(Config.SirenData[Model]['SoundId'])
        end
    end
end

RegisterNUICallback('CloseUi', function()
    Config.UiOpend = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false, false)
    TriggerServerEvent('fw-emergencylights:server:set:sounds:disabled')
end)

RegisterNUICallback('Click', function()
    PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end)

RegisterNUICallback('RegisterButton', function(data)
    local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
    local Plate = GetVehicleNumberPlateText(Vehicle)
    TriggerServerEvent('fw-emergencylights:server:update:button', data, Plate)
end)

RegisterNUICallback('SetLights', function(data)
    local Count = 0
    local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
    local ModelName = GetEntityModel(Vehicle)
    if data.State == 1 then
        for k, v in pairs(Config.SirenData[ModelName]['LightSettings'][data.Type]) do
         SetVehicleExtra(Vehicle, v, 1)
        end
        for i = 1, 12, 1 do
            if IsVehicleExtraTurnedOn(Vehicle, i) then
                Count = Count + 1
            end
        end
        if Count <= 0 then
            SetVehicleSiren(Vehicle, false)
        end
    else
        for k, v in pairs(Config.SirenData[ModelName]['LightSettings'][data.Type]) do
         SetVehicleExtra(Vehicle, v, 0)
        end
        SetVehicleSiren(Vehicle, true)
    end
end)

RegisterNUICallback('SetSirens', function(data)
   TriggerServerEvent('fw-emergencylights:server:toggle:sounds', data.Bool)
end)

function IsVehicleUnmarked(VehicleModel)
    if Config.SirenData[VehicleModel]['IsUnmarked'] then
        return true
    else 
        return false
    end
end

function SetupEmergencyVehicle(Vehicle)
    Config.EmergencyData[GetVehicleNumberPlateText(Vehicle)] = {['SirenState'] = false, ['SoundId'] = nil}
    TriggerServerEvent('fw-emergencylights:server:setup:first:time', GetVehicleNumberPlateText(Vehicle))
    for i = 1, 15 do
        SetVehicleExtra(Vehicle, i, 1)
    end
end