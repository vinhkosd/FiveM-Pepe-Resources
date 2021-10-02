Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('fw-appartments:server:set:appartment:data')
AddEventHandler('fw-appartments:server:set:appartment:data', function(AppartmentName)
local Player = Framework.Functions.GetPlayer(source)
local NewAppartmentData = {Id = Player.PlayerData.metadata['appartment-data'].Id, Name = AppartmentName}
    Player.Functions.SetMetaData("appartment-data", NewAppartmentData)
    TriggerClientEvent('fw-appartments:client:enter:appartment', source, true, AppartmentName)
end)

RegisterServerEvent('fw-appartments:server:logout')
AddEventHandler('fw-appartments:server:logout', function()
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 local PlayerItems = Player.PlayerData.items
 TriggerClientEvent('fw-radio:onRadioDrop', src)
 if PlayerItems ~= nil then
    Framework.Functions.ExecuteSql(true, "UPDATE `characters_metadata` SET `inventory` = '"..Framework.EscapeSqli(json.encode(MyItems)).."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
 else
    Framework.Functions.ExecuteSql(true, "UPDATE `characters_metadata` SET `inventory` = '{}' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
 end
 Framework.Player.Logout(src)
 Citizen.Wait(450)
 TriggerClientEvent('fw-multichar:client:open:select', src)
end)

function GetAppartmentName(AppartmentId)
    return Config.Locations[AppartmentId]['Label']
end

Framework.Commands.Add("searchappartment", "Open een appartement stash", {{name="id", help="Appartement ID"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local AppartementID = args[1]
    if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'judge' and Player.PlayerData.metadata['ishighcommand'] then
        TriggerClientEvent('fw-appartments:client:open:appartment:stash', source, AppartementID)
    end
end)