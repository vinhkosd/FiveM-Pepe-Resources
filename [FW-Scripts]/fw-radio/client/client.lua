local RadioOn = false
local isLoggedIn = false
local LastRadioChannel = -1
local CurrentVolume = 5
local Framework = nil

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(350, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end) 
	   Citizen.Wait(250)
     isLoggedIn = true
 end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if isLoggedIn then
      Framework.Functions.TriggerCallback('fw-radio:server:HasItem', function(HasItem)
          if not HasItem then
             if exports.tokovoip_script:getPlayerData(GetPlayerName(PlayerId()), "radio:channel") ~= 'nil' then
               LeaveRadio(true)
             end
          end
      end, "radio")
      Citizen.Wait(5000)
    else
      Citizen.Wait(1000)  
    end
  end
end)

-- // Events \\ --

RegisterNetEvent('fw-radio:drop:radio')
AddEventHandler('fw-radio:drop:radio', function()
  Framework.Functions.TriggerCallback('fw-radio:server:HasItem', function(HasItem)
    if not HasItem then
       LeaveRadio()
    end
  end, "radio")
end)

RegisterNetEvent('fw-radio:use:radio')
AddEventHandler('fw-radio:use:radio', function()
  Citizen.SetTimeout(1000, function()
    OpenRadio()
  end)
end)

-- // Functions \\ --

RegisterNUICallback('JoinRadio', function(data)
  JoinRadio(data.channel, data.channel:len())
end)

RegisterNUICallback('LeaveRadio', function(data, cb)
  LeaveRadio()
end)

RegisterNUICallback('Escape', function(data, cb)
  SetNuiFocus(false, false)
  PhonePlayOut()
end)

RegisterNUICallback('SetVolume', function(data)
  if data.Type == 'Up' then
    if CurrentVolume < 5 then
      CurrentVolume = CurrentVolume + 1
     exports['tokovoip_script']:setRadioVolume(Config.VolumeSettings[CurrentVolume])
     Framework.Functions.Notify('Geluids Instelling: '..CurrentVolume, 'success')
    else
     Framework.Functions.Notify('Volume kan niet hoger dan instelling 5', 'error')
    end
  elseif data.Type == 'Down' then
    if CurrentVolume > 1 then
      CurrentVolume = CurrentVolume - 1
      exports['tokovoip_script']:setRadioVolume(Config.VolumeSettings[CurrentVolume])
      Framework.Functions.Notify('Geluids Instelling: '..CurrentVolume, 'success')
     else
      Framework.Functions.Notify('Volume kan niet lager dan instelling 1.', 'error')
     end
  end
end)

RegisterNUICallback('ToggleOnOff', function()
  local CurrentRadioChannel = exports.tokovoip_script:getPlayerData(GetPlayerName(PlayerId()), "radio:channel")
  Citizen.SetTimeout(150, function()
     if not RadioOn then
       RadioOn = true
       if LastRadioChannel ~= -1 then
         SendNUIMessage({type = 'setchannel', channel = LastRadioChannel})
         exports.tokovoip_script:addPlayerToRadio(LastRadioChannel, "Radio", "radio")
         exports.tokovoip_script:setPlayerData(GetPlayerName(PlayerId()), "radio:channel", LastRadioChannel, true);
        else
          SendNUIMessage({type = "setchannel", channel = 0})
       end
       TriggerEvent("fw-sound:client:play", "radio-on", 0.25)
       Framework.Functions.Notify('Radio Aan..', 'success')
     else
        RadioOn = false
        if CurrentRadioChannel ~= nil and CurrentRadioChannel ~= 'nil' and CurrentRadioChannel ~= false then
         exports.tokovoip_script:removePlayerFromRadio(CurrentRadioChannel)
         exports.tokovoip_script:setPlayerData(GetPlayerName(PlayerId()), "radio:channel", 'nil', true);
        end
        SendNUIMessage({type = "setchannel", channel = 'Uit'})
        TriggerEvent("fw-sound:client:play", "radio-click", 0.25)
        Framework.Functions.Notify('Radio Uit..', 'error')
     end
  end)
end)

RegisterNUICallback('OnClick', function()
  PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end)

function JoinRadio(Channel, StringLenght)
local JoinChannel = tonumber(Channel)
local PlayerData = Framework.Functions.GetPlayerData()
 if RadioOn then
    if JoinChannel <= Config.MaxFrequency then
        if JoinChannel ~= exports.tokovoip_script:getPlayerData(GetPlayerName(PlayerId()), "radio:channel") then
            if JoinChannel <= Config.RestrictedChannels then 
                 if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
                  LastRadioChannel = JoinChannel 
                  exports.tokovoip_script:removePlayerFromRadio(exports.tokovoip_script:getPlayerData(GetPlayerName(PlayerId()), "radio:channel"))
                  exports.tokovoip_script:setPlayerData(GetPlayerName(PlayerId()), "radio:channel", JoinChannel, true);
                  exports.tokovoip_script:addPlayerToRadio(JoinChannel, "Radio", "radio")
                  if StringLenght >= 4 then
                    Framework.Functions.Notify('Verbonden met '..JoinChannel..' Mhz', 'success')
                  else
                    Framework.Functions.Notify('Verbonden met '..JoinChannel..'.00 Mhz', 'success')
                  end
                 else
                  Framework.Functions.Notify('Deze kanalen zijn gecodeerd..', 'error')
                 end
            end
            if JoinChannel > Config.RestrictedChannels then
              LastRadioChannel = JoinChannel
              exports.tokovoip_script:removePlayerFromRadio(exports.tokovoip_script:getPlayerData(GetPlayerName(PlayerId()), "radio:channel"))
              exports.tokovoip_script:setPlayerData(GetPlayerName(PlayerId()), "radio:channel", JoinChannel, true);
              exports.tokovoip_script:addPlayerToRadio(JoinChannel, "Radio", "radio")
              if StringLenght >= 4 then
                Framework.Functions.Notify('Verbonden met '..JoinChannel..'Mhz', 'success')
              else
                Framework.Functions.Notify('Verbonden met '..JoinChannel..'.00 Mhz', 'success')
              end
            end
        else
           Framework.Functions.Notify('Je zit al op deze frequentie..', 'error')
      end
    else
      Framework.Functions.Notify('Deze frequentie kan je niet joinen..', 'success')
    end
 else
   Framework.Functions.Notify('Je radio staat niet aan..', 'error')
 end
end

function LeaveRadio(Forced)
  if RadioOn or Forced then
    LastRadioChannel = -1
    TriggerEvent("fw-sound:client:play", "radio-click", 0.25)
    exports.tokovoip_script:removePlayerFromRadio(exports.tokovoip_script:getPlayerData(GetPlayerName(PlayerId()), "radio:channel"))
    exports.tokovoip_script:setPlayerData(GetPlayerName(PlayerId()), "radio:channel", 'nil', true);
    TriggerServerEvent("TokoVoip:removePlayerFromAllRadio", GetPlayerServerId(PlayerId()))
    Framework.Functions.Notify('Bạn đã rời khỏi bộ đàm!', 'error')
  else
    Framework.Functions.Notify('Bạn đang không bật bộ đàm..', 'error')
  end
end

function SetRadioState(bool)
  RadioOn = bool
end

function OpenRadio()
   PhonePlayIn()
   SetNuiFocus(true, true)
   SendNUIMessage({
     type = "open",
   })
end