local FakeChars = {}
local SpawnCam = nil
local CharData = {}
local FirstSpawn = false

local Framework = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if Framework == nil then
            TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
            Citizen.Wait(200)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NetworkIsSessionStarted() then
			TriggerEvent('fw-multichar:client:open:select')
			return
		end
	end
end)

RegisterNetEvent('fw-multichar:client:set:data')
AddEventHandler('fw-multichar:client:set:data', function(Slot, CitizenId, Model, Skin)
    Config.Peds[Slot]['CitizenId'] = CitizenId
    Config.Peds[Slot]['Model'] = tonumber(Model)
    Config.Peds[Slot]['Skin'] = json.decode(Skin)
end)

RegisterNetEvent('fw-multichar:client:open:select')
AddEventHandler('fw-multichar:client:open:select', function()
    DoScreenFadeOut(10)
    Citizen.Wait(1000)
    TriggerServerEvent('fw-multichar:server:set:data')
    Citizen.SetTimeout(4500, function()
        SendNUIMessage({action = "OpenCharSelect"})
        SetNuiFocus(true, true)
        SetEntityCoords(PlayerPedId(), -411.42, 1179.48, 326.15)
		FreezeEntityPosition(PlayerPedId(), true)		
        DestroyAllCams()
        SpawnCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -411.42, 1174.48, 326.15, 0.00, 0.00, 162.95, 60.00, false, 0)
        PointCamAtCoord(SpawnCam, -411.42, 1174.48, 326.15)
        SetCamActive(SpawnCam, true)
        RenderScriptCams(true, false, 1, true, true)
        SetRainFxIntensity(0.0)
        SetWeatherTypePersist('EXTRASUNNY')
        SetWeatherTypeNow('EXTRASUNNY')
        SetWeatherTypeNowPersist('EXTRASUNNY')
        NetworkOverrideClockTime(0, 0, 0)
        ShutdownLoadingScreenNui()
        ShutdownLoadingScreen()
        Citizen.Wait(750)
        DoScreenFadeIn(1000)
        LoadModels()
        Citizen.Wait(1500)
        CreatePeds()
    end)
end)

function CreatePeds()
    for k, v in pairs(Config.Peds) do
        local LoadModel = GetHashKey('mp_m_freemode_01')
        if v['Model'] ~= nil then
            LoadModel = v['Model']
        end
        exports['fw-assets']:RequestModelHash(LoadModel)
        local CharPeds = CreatePed(2, LoadModel, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], 200.0, false, false)
        while not DoesEntityExist(CharPeds) do
         Wait(100)
        end
        if v['Skin'] ~= nil then
            TriggerEvent('fw-clothing:client:loadPlayerClothing', v['Skin'], CharPeds)
        end
        NetworkSetEntityInvisibleToNetwork(CharPeds, true)
        SetEntityInvincible(CharPeds, true)
        SetEntityCanBeDamagedByRelationshipGroup(CharPeds, false, `PLAYER`)
        Citizen.Wait(850)
        TaskGoToCoordAnyMeans(CharPeds, v['WalkCoords']['X'], v['WalkCoords']['Y'], v['WalkCoords']['Z'], 1.0, 0, 0, 0, 0.5)
        Citizen.Wait(v['Wait'])
        SendNUIMessage({action = "ShowCard", slot = k})
        TaskAchieveHeading(CharPeds, v['Heading'], 0)
        table.insert(FakeChars, CharPeds)
    end
    SendNUIMessage({action = "EnableChoose"})
end

function LoadModels()
    RequestModel(GetHashKey("mp_m_freemode_01"))
    RequestModel(GetHashKey("mp_f_freemode_01"))
    while not HasModelLoaded(GetHashKey("mp_m_freemode_01")) do
		Wait(500)
		RequestModel(GetHashKey("mp_m_freemode_01"))
	end
	while not HasModelLoaded(GetHashKey("mp_f_freemode_01")) do
		Wait(500)
		RequestModel(GetHashKey("mp_f_freemode_01"))
	end
end

function RemoveFakePeds()
    for k, v in pairs(FakeChars) do
        DeletePed(v)  
    end
    FakeChars = {}
end

function ResetCitizenId()
    for k, v in pairs(Config.Peds) do
        v['CitizenId'] = ''
        v['Skin'] = nil
        v['Model'] = nil
    end
end

RegisterNUICallback('GetCharacters', function(data, cb)
    Framework.Functions.TriggerCallback('fw-multichar:server:get:characters', function(Characters)
        cb(Characters)
    end)
end)

RegisterNUICallback('Click', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('ClickedCard', function(data)
    exports['fw-assets']:RequestAnimationDict("friends@frj@ig_1")
    TaskPlayAnim(FakeChars[data.Slot], 'friends@frj@ig_1', 'wave_d', 3.0, 3.0, -1, 49, 0, false, false, false)
    Citizen.Wait(GetAnimDuration('friends@frj@ig_1', 'wave_d') * 1000)
    ClearPedTasks(FakeChars[data.Slot])
end)

RegisterNUICallback('SelectCharacter', function(data)
    CharCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetOffsetFromEntityInWorldCoords(FakeChars[data.Slot], 0.0, 12.0, 1.3), 0.00, 0.00, 0.00, 8.00, false, 0)
    PointCamAtEntity(CharCam, FakeChars[data.Slot])
    SetCamActiveWithInterp(CharCam, SpawnCam, 2500, true, true)
    Citizen.Wait(2500)
    exports['fw-assets']:RequestAnimationDict("anim@mp_fm_event@intro")
    PlayAmbientSpeech1(FakeChars[data.Slot], "GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL")
    TaskPlayAnim(FakeChars[data.Slot], 'anim@mp_fm_event@intro', 'beast_transform', 3.0, 3.0, -1, 49, 0, false, false, false)
    Citizen.SetTimeout(2000, function()
        DoScreenFadeOut(150)
        Citizen.Wait(150)
        RemoveFakePeds()
        ResetCitizenId()
        TriggerServerEvent('fw-multichar:server:select:char', data.Citizenid)
    end)
end)

RegisterNUICallback('DeleteCharacter', function(data)
    SetEntityHealth(FakeChars[data.Slot], 0.0)
    Citizen.SetTimeout(1750, function()
        DoScreenFadeOut(150)
        Citizen.Wait(150)
        RemoveFakePeds()
        ResetCitizenId()
        TriggerServerEvent('fw-multichar:server:delete:char', data.Citizenid)
    end)
end)

RegisterNUICallback('CreateNewChar', function(data)
    local NewCharData = {Slot = data.Slot, Firstname = data.FirstName, Lastname = data.LastName, Birthdate = data.BirthDate, Gender = data.Gender}
    CharCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetOffsetFromEntityInWorldCoords(FakeChars[data.Slot], 0.0, 12.0, 1.3), 0.00, 0.00, 0.00, 8.00, false, 0)
    PointCamAtEntity(CharCam, FakeChars[data.Slot])
    SetCamActiveWithInterp(CharCam, SpawnCam, 2500, true, true)
    exports['fw-assets']:RequestAnimationDict("anim@mp_fm_event@intro")
    PlayAmbientSpeech1(FakeChars[data.Slot], "GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL")
    TaskPlayAnim(FakeChars[data.Slot], 'anim@mp_fm_event@intro', 'beast_transform', 3.0, 3.0, -1, 49, 0, false, false, false)
    Citizen.SetTimeout(2000, function()
        DoScreenFadeOut(150)
        Citizen.Wait(150)
        RemoveFakePeds()
        ResetCitizenId()
        TriggerServerEvent('fw-multichar:server:create:new:char', NewCharData)
    end)
end)

RegisterNUICallback('CloseNui', function()
    SetNuiFocus(false, false)
end)