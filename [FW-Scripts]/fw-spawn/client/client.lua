local Cam, Cam2 = nil, nil

Framework = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if Framework == nil then
            TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
            Citizen.Wait(200)
        end
    end
end)

-- Code

RegisterNetEvent('fw-spawn:client:choose:spawn')
AddEventHandler('fw-spawn:client:choose:spawn', function()
    Citizen.SetTimeout(450, function()
      Framework.Functions.GetPlayerData(function(PlayerData)
        local InJail = false
        if PlayerData.metadata["jailtime"] > 0 then
            InJail = true
        end
        print(PlayerData.metadata["jailtime"], InJail)
        SetEntityVisible(GetPlayerPed(-1), false)
        DoScreenFadeOut(250)
        Citizen.Wait(2000)
        DoScreenFadeIn(250)
        SetSkyCam(true)
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'spawn',
            injail = InJail,
        })
      end)
    end)
end)

RegisterNetEvent('fw-spawn:client:choose:appartment')
AddEventHandler('fw-spawn:client:choose:appartment', function()
    SetEntityVisible(GetPlayerPed(-1), false)
    DoScreenFadeOut(250)
    Citizen.Wait(2000)
    DoScreenFadeIn(250)
    SetSkyCam(true)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'new',
    })
end)

RegisterNUICallback('SpawnPlayer', function(data)
    Citizen.Wait(2000)
    SpawnPlayer(data.SpawnId)
    TriggerEvent('Framework:Client:OnPlayerLoaded')
end)

RegisterNUICallback('ChooseAppartment', function(data)
    DoScreenFadeOut(250)
    Citizen.Wait(100)
    SetSkyCam(false)
    TriggerEvent('Framework:Client:OnPlayerLoaded')
    TriggerServerEvent('fw-appartments:server:set:appartment:data', data.AppId)
end)

RegisterNUICallback('SpawnJail', function(data)
    DoScreenFadeOut(250)
    Citizen.Wait(100)
    SetSkyCam(false)
    TriggerEvent('Framework:Client:OnPlayerLoaded')
    Citizen.Wait(100)
    TriggerEvent('fw-prison:client:spawn:prison')
end)

RegisterNUICallback('Close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('Click', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

function SetSkyCam(bool)
  if bool then
        Cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -265.51, -811.01, 31.85 + 300, -85.00, 0.00, 0.00, 100.00, false, 0)
        SetCamActive(Cam, true)
        SetFocusArea(-265.51, -811.01, 31.85 + 175, 0.0, 0.0, 0.0)
        ShakeCam(Cam, "HAND_SHAKE", 0.15)
        SetEntityVisible(GetPlayerPed(-1), false)
        RenderScriptCams(true, false, 3000, 1, 1)
  else
      if DoesCamExist(Cam) then
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(Cam, false)
        DestroyCam(Cam, true)
      end
      SetFocusEntity(GetPlayerPed(-1))
      FreezeEntityPosition(GetPlayerPed(-1), false)
      SetEntityVisible(GetPlayerPed(-1), true)
  end
end

function SpawnPlayer(SpawnId)
    if SpawnId == 'lastlocation' then
        Framework.Functions.GetPlayerData(function(PlayerData)
          SetEntityCoords(GetPlayerPed(-1), PlayerData.position.x, PlayerData.position.y, PlayerData.position.z - 0.9, 0, 0, 0, false)
          SetFocusArea(PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + 300, 0.0, 0.0, 0.0)
          SetCamParams(Cam, PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + 300, -85.0, 0.00, 0.00, 100.0, 7200, 0, 0, 2)
          Citizen.Wait(6500)
          SetFocusArea(PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + 10, 0.0, 0.0, 0.0)
          SetCamParams(Cam, PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + 10, -40.0, 0.00, 0.00, 100.0, 5000, 0, 0, 2)
          Citizen.Wait(4500)
          Citizen.SetTimeout(1000, function()
             SetSkyCam(false)
             Citizen.Wait(100)
             DoScreenFadeOut(250)
             Citizen.Wait(150)
             SetSkyCam(false)
             Citizen.Wait(1000)
             DoScreenFadeIn(1000)
          end)
        end)
    else
        SetFocusArea(Config.Locations[SpawnId]['Coords']['X'], Config.Locations[SpawnId]['Coords']['Y'], Config.Locations[SpawnId]['Coords']['Z'] + Config.Locations[SpawnId]['Coords']['Z-Offset'], 0.0, 0.0, 0.0)
        SetCamParams(Cam, Config.Locations[SpawnId]['Coords']['X'], Config.Locations[SpawnId]['Coords']['Y'], Config.Locations[SpawnId]['Coords']['Z'] + Config.Locations[SpawnId]['Coords']['Z-Offset'], Config.Locations[SpawnId]['Coords']['XR'], 0.00, 0.00, 100.0, 7200, 0, 0, 2)
        SetEntityCoords(GetPlayerPed(-1), Config.Locations[SpawnId]['Coords']['X'], Config.Locations[SpawnId]['Coords']['Y'], Config.Locations[SpawnId]['Coords']['Z'] - 0.9, 0, 0, 0, false)
        SetEntityHeading(GetPlayerPed(-1), Config.Locations[SpawnId]['Coords']['H'])
        Citizen.Wait(6500)
        if SpawnId == 'spawn4' or SpawnId == 'spawn5' then
            SetFocusArea(Config.Locations[SpawnId]['Coords']['X'], Config.Locations[SpawnId]['Coords']['Y'], Config.Locations[SpawnId]['Coords']['Z'] + 10, 0.0, 0.0, 0.0)
            SetCamParams(Cam, Config.Locations[SpawnId]['Coords']['X'], Config.Locations[SpawnId]['Coords']['Y'], Config.Locations[SpawnId]['Coords']['Z'] + 10, -40.0, 0.00, 0.00, 100.0, 5000, 0, 0, 2)
          Citizen.Wait(4500)
        end
        Citizen.SetTimeout(1000, function()
           SetSkyCam(false)
           Citizen.Wait(100)
           DoScreenFadeOut(250)
           Citizen.Wait(150)
           SetSkyCam(false)
           Citizen.Wait(1000)
           DoScreenFadeIn(1000)
        end)
    end
end