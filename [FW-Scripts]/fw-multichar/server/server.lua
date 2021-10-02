local Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Commands.Add("logout", "Ga naar het karakter menu.", {}, false, function(source, args)
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
    Citizen.Wait(550)
    TriggerClientEvent('fw-multichar:client:open:select', src)
end, "admin")

Framework.Functions.CreateCallback("fw-multichar:server:get:characters", function(source, cb)
    local CharactersTable = {}
    local src = source
    Framework.Functions.ExecuteSql(false, "SELECT * FROM characters_metadata WHERE `steam` = '"..GetPlayerIdentifiers(src)[1].."'", function(result)
        for k, v in pairs(result) do
            local TempTable = {}
            local CharInfo = json.decode(v.charinfo)
            local Job = json.decode(v.job)
            table.insert(CharactersTable, {Name = CharInfo.firstname..' '..CharInfo.lastname, CharSlot = v.cid, Citizenid = v.citizenid, Job = Job.label})
        end
        cb(CharactersTable)
    end)
end)

RegisterServerEvent('fw-multichar:server:set:data')
AddEventHandler('fw-multichar:server:set:data', function()
    local src = source
    Framework.Functions.ExecuteSql(false, "SELECT * FROM characters_metadata WHERE `steam` = '"..GetPlayerIdentifiers(src)[1].."'", function(result)
        for k, v in pairs(result) do
            Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_skins` WHERE `citizenid` = '"..v.citizenid.."'", function(modelresult)
                if modelresult ~= nil and modelresult[1] ~= nil then
                    TriggerClientEvent('fw-multichar:client:set:data', src, v.cid, v.citizenid, modelresult[1].model, modelresult[1].skin)
                else
                    TriggerClientEvent('fw-multichar:client:set:data', src, v.cid, v.citizenid, nil, nil)
                end
            end)
        end
    end)
end)

RegisterServerEvent('fw-multichar:server:select:char')
AddEventHandler('fw-multichar:server:select:char', function(CitizenId)
    local src = source
    if Framework.Player.Login(src, false, CitizenId) then
        TriggerClientEvent('fw-spawn:client:choose:spawn', src)
        TriggerEvent("fw-logs:server:SendLog", "joinleave", "Loaded", "green", "**".. GetPlayerName(src) .. "** ("..CitizenId.." | "..src..") loaded..")
	end
end)

RegisterServerEvent('fw-multichar:server:create:new:char')
AddEventHandler('fw-multichar:server:create:new:char', function(NewCharData)
    local src = source
    local newData = {firstname = NewCharData.Firstname, lastname = NewCharData.Lastname, birthdate = NewCharData.Birthdate, nationality = 'Los Santos', gender = NewCharData.Gender, cid = NewCharData.Slot}
    if Framework.Player.Login(src, true, false, newData) then
        Framework.Commands.Refresh(src)
        GiveStarterItems(src)
        TriggerClientEvent('fw-spawn:client:choose:appartment', src)
        TriggerEvent("fw-logs:server:SendLog", "joinleave", "Character Creation", "green", "**".. GetPlayerName(src) .. "** ("..src..") Created their character..")
	end
end)

RegisterServerEvent('fw-multichar:server:delete:char')
AddEventHandler('fw-multichar:server:delete:char', function(CitizenId)
    Framework.Player.DeleteCharacter(source, CitizenId)
end)

function GiveStarterItems(source)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    for k, v in pairs(Framework.Shared.StarterItems) do
        local info = {}
        if v.item == "id-card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "drive-card" then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = "A1-A2-A | AM-B | C1-C-CE"
        end
        Player.Functions.AddItem(v.item, v.amount, false, info)
    end
end