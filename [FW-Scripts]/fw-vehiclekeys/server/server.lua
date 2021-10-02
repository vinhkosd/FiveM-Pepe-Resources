Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback("fw-vehiclekeys:server:get:key:config", function(source, cb)
  cb(Config)
end)

Framework.Functions.CreateCallback("fw-vehiclekeys:server:has:keys", function(source, cb, plate)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    if Config.VehicleKeys[plate] ~= nil then
        if Config.VehicleKeys[plate]['CitizenId'] == Player.PlayerData.citizenid and Config.VehicleKeys[plate]['HasKey'] then
            HasKey = true
        else
            HasKey = false
        end
    else
        HasKey = false
    end
    cb(HasKey)
end)

-- // Events \\ --

RegisterServerEvent('fw-vehiclekeys:server:set:keys')
AddEventHandler('fw-vehiclekeys:server:set:keys', function(Plate, bool)
  local Player = Framework.Functions.GetPlayer(source)
  Config.VehicleKeys[Plate] = {['CitizenId'] = Player.PlayerData.citizenid, ['HasKey'] = bool}
  TriggerClientEvent('fw-vehiclekeys:client:set:keys', -1, Plate, Player.PlayerData.citizenid, bool)
end)

RegisterServerEvent('fw-vehiclekeys:server:give:keys')
AddEventHandler('fw-vehiclekeys:server:give:keys', function(Target, Plate, bool)
  local Player = Framework.Functions.GetPlayer(Target)
  if Player ~= nil then
    TriggerClientEvent('Framework:Notify', Player.PlayerData.source, "Je ontving sleutels van een voertuig met het kenteken: "..Plate, 'success')
    Config.VehicleKeys[Plate] = {['CitizenId'] = Player.PlayerData.citizenid, ['HasKey'] = bool}
    TriggerClientEvent('fw-vehiclekeys:client:set:keys', -1, Plate, Player.PlayerData.citizenid, bool)
  end
end)

-- // Commands \\ -- 

Framework.Commands.Add("motor", "Toggle motor aan/uit van het voertuig", {}, false, function(source, args)
  TriggerClientEvent('fw-vehiclekeys:client:toggle:engine', source)
end)