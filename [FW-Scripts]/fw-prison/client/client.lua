local JailTime = 0
local InJail = false
local AlertSended = false
local isLoggedIn = false

Framework = nil

RegisterNetEvent("Framework:Client:OnPlayerLoaded")
AddEventHandler("Framework:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(500, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
     Citizen.Wait(150)
     isLoggedIn = true
    end) 
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    InJail = false
    JailTime = 0
    isLoggedIn = false
end)

RegisterNetEvent('fw-prison:client:spawn:prison')
AddEventHandler('fw-prison:client:spawn:prison', function()
  Citizen.SetTimeout(550, function()
    Framework.Functions.GetPlayerData(function(PlayerData)
     local RandomStartPosition = Config.Locations['Spawns'][math.random(1, #Config.Locations['Spawns'])]
     TriggerEvent('fw-sound:client:play', 'jail-door', 0.5)
     Citizen.Wait(450)
     SetEntityCoords(GetPlayerPed(-1), RandomStartPosition['Coords']['X'], RandomStartPosition['Coords']['Y'], RandomStartPosition['Coords']['Z'] - 0.9, 0, 0, 0, false)
     SetEntityHeading(GetPlayerPed(-1), RandomStartPosition['Coords']['H'])
     Citizen.Wait(1000)
     TriggerEvent('animations:client:EmoteCommandStart', {RandomStartPosition['Animation']})
     Citizen.Wait(2000)
     InJail = true
     JailTime = PlayerData.metadata["jailtime"]
     Framework.Functions.Notify("Je zit in de gevangenis voor "..JailTime.." maand(en)..", "error", 6500)
     DoScreenFadeIn(1000)
    end)
  end)
end)

-- Code

-- // Events \\ --

RegisterNetEvent('fw-prison:client:enter:prison')
AddEventHandler('fw-prison:client:enter:prison', function(Time, bool)
    JailTime = Time
    InJail = bool
end)

RegisterNetEvent('fw-prison:client:set:alarm')
AddEventHandler('fw-prison:client:set:alarm', function(bool)
  if bool then
    while not PrepareAlarm("PRISON_ALARMS") do
        Citizen.Wait(10)
    end
    StartAlarm("PRISON_ALARMS", true)
    Citizen.Wait(60 * 1000)
    StopAllAlarms(true)
  else
    StopAllAlarms(true)
  end
end)

RegisterNetEvent('fw-prison:client:leave:prison')
AddEventHandler('fw-prison:client:leave:prison', function()
  local RandomSeat = Config.Locations['Leave-Spawn'][math.random(1, #Config.Locations['Leave-Spawn'])]
  DoScreenFadeOut(1000)
  Citizen.Wait(1000)
  TriggerEvent('fw-sound:client:play', 'jail-cell', 0.2)
  SetEntityCoords(GetPlayerPed(-1), RandomSeat['Coords']['X'], RandomSeat['Coords']['Y'], RandomSeat['Coords']['Z'] - 0.9, 0, 0, 0, false)
  SetEntityHeading(GetPlayerPed(-1), RandomSeat['Coords']['H'])
  Citizen.Wait(250)
  TriggerEvent('animations:client:EmoteCommandStart', {RandomSeat['Animation']})
  Citizen.Wait(2000)
  DoScreenFadeIn(1000)
end)

-- // Loops \\ --

Citizen.CreateThread(function()
	while true do 
    Citizen.Wait(4)
      if isLoggedIn then
        if InJail then
          if JailTime > 0 then
            Citizen.Wait(1000 * 60)
            JailTime = JailTime - 1
            TriggerServerEvent("fw-prison:server:set:jail:state", JailTime)
            if JailTime == 0 and not AlertSended then
              AlertSended = true
              JailTime = 0
              TriggerServerEvent("fw-prison:server:set:jail:leave")
              Framework.Functions.Notify("Je tijd zit erop! Check jezelf uit!", "success")
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
    Citizen.Wait(7)
    if isLoggedIn then
      if InJail then
		    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["Prison"]['Coords']['X'], Config.Locations["Prison"]['Coords']['Y'], Config.Locations["Prison"]['Coords']['Z'], false) > 202.0 and InJail) then
          InJail = false
          JailTime = 0
          AlertSended = false
          TriggerServerEvent("fw-prison:server:set:jail:leave")
          TriggerServerEvent('fw-prison:server:set:alarm', true)
          Framework.Functions.Notify("Je bent de gevangenis ontsnapt.. Maak dat je weg komt!", "error")
        else
          Citizen.Wait(5000)
        end
      else
        Citizen.Wait(5000)
      end
   end
	end
end)

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(4)
      if isLoggedIn then
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        InRange = false

        if InJail then

          
           local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Leave']['Coords']['X'], Config.Locations['Leave']['Coords']['Y'], Config.Locations['Leave']['Coords']['Z'], true)
          
           if Distance < 2.5 then
            if JailTime <= 0 then
              DrawText3D(Config.Locations['Leave']['Coords']['X'], Config.Locations['Leave']['Coords']['Y'], Config.Locations['Leave']['Coords']['Z'] + 0.1, '~g~E~s~ - Verlaten')
              if IsControlJustReleased(0, 38) then
                InJail = false
                AlertSended = false
                TriggerServerEvent("fw-prison:server:get:items:back")
                TriggerServerEvent("fw-prison:server:set:jail:leave")
                TriggerEvent('fw-prison:client:leave:prison')
              end
            else
              DrawText3D(Config.Locations['Leave']['Coords']['X'], Config.Locations['Leave']['Coords']['Y'], Config.Locations['Leave']['Coords']['Z'] + 0.1, 'Wacht: ~r~'..JailTime.. '~s~ Maand(en)')
            end
               DrawMarker(2, Config.Locations['Leave']['Coords']['X'], Config.Locations['Leave']['Coords']['Y'], Config.Locations['Leave']['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
             InRange = true
           end
   
           for k, v in pairs(Config.Locations['Search']) do
           local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
             if Distance < 2.5 then
               DrawMarker(2, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)     
               DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z']+0.1, '~g~E~s~ - ??')
               if IsControlJustReleased(0, 38) then
                 SearchPlace(v['Reward'], v['Chance'])
               end
               InRange = true
             end
           end

          
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Shop']['Coords']['X'], Config.Locations['Shop']['Coords']['Y'], Config.Locations['Shop']['Coords']['Z'], true)
              if Distance < 2.5 then
                DrawMarker(2, Config.Locations['Shop']['Coords']['X'], Config.Locations['Shop']['Coords']['Y'], Config.Locations['Shop']['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)     
                DrawText3D(Config.Locations['Shop']['Coords']['X'], Config.Locations['Shop']['Coords']['Y'], Config.Locations['Shop']['Coords']['Z']+0.1, '~g~E~s~ - ??')
                if IsControlJustReleased(0, 38) then
                  TriggerServerEvent("fw-inventory:server:OpenInventory", "shop", "prison", Config.Items)
                end
                InRange = true
              end
            


           

           if not InRange then
             Citizen.Wait(1500)
           end

      else
        Citizen.Wait(1500)
      end
    else
      Citizen.Wait(1500)
     end
    end
end)

-- // Functions \\ --

function SearchPlace(Reward, Chance)
  local Label = 'Zoeken..'
  if Reward == 'slushy' then
    Label = 'Slushy maken..'
  end
  Framework.Functions.Progressbar("search-jail", Label, math.random(5000, 6500), false, true, {
      disableMovement = false,
      disableCarMovement = true,
      disableMouse = false,
      disableCombat = true,
  }, {}, {}, {}, function() -- Done
    if math.random(1,100) < Chance then
      -- GiveItem Reward
      TriggerServerEvent('fw-prison:server:find:reward', Reward)
      Framework.Functions.Notify("WOW Thats hot!", "success")
    else
      Framework.Functions.Notify("Helemaal niks..", "error") 
    end
  end, function() -- Cancel
    Framework.Functions.Notify("Đã hủy..", "error") 
  end)
end

function DrawText3D(x, y, z, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x,y,z, 0)
  DrawText(0.0, 0.0)
  ClearDrawOrigin()
 end

 function GetInJailStatus()
  return InJail
 end