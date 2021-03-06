Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local permissions = {
    ["kick"] = "admin",
    ["ban"] = "admin",
    ["noclip"] = "admin",
    ["kickall"] = "admin",
    ["devmode"] = "admin",
}

RegisterServerEvent('fw-admin:server:togglePlayerNoclip')
AddEventHandler('fw-admin:server:togglePlayerNoclip', function(playerId, reason)
    local src = source
    if Framework.Functions.HasPermission(src, permissions["noclip"]) then
        TriggerClientEvent("fw-admin:client:toggleNoclip", playerId)
    end
end)

RegisterServerEvent('fw-admin:server:debugtool')
AddEventHandler('fw-admin:server:debugtool', function()
    local src = source
    if Framework.Functions.HasPermission(src, permissions["devmode"]) then
        TriggerClientEvent('koil-debug:toggle', src)
    end
end)

RegisterServerEvent('fw-admin:server:killPlayer')
AddEventHandler('fw-admin:server:killPlayer', function(playerId)
    TriggerClientEvent('hospital:client:KillPlayer', playerId)
end)

RegisterServerEvent('fw-admin:server:kickPlayer')
AddEventHandler('fw-admin:server:kickPlayer', function(playerId, reason)
    local src = source
    if Framework.Functions.HasPermission(src, permissions["kick"]) then
        DropPlayer(playerId, "\nš Je bent gekicked uit de server:\nš Reden: "..reason.."\n\n")
    end
end)

RegisterServerEvent('fw-admin:server:Freeze')
AddEventHandler('fw-admin:server:Freeze', function(playerId, toggle)
    TriggerClientEvent('fw-admin:client:Freeze', playerId, toggle)
end)

RegisterServerEvent('fw-admin:server:serverKick')
AddEventHandler('fw-admin:server:serverKick', function(reason)
    local src = source
    if Framework.Functions.HasPermission(src, permissions["kickall"]) then
        for k, v in pairs(Framework.Functions.GetPlayers()) do
            if v ~= src then 
                DropPlayer(v, "\nš Je bent gekicked uit de server:\nš Reden: Server Restart..\n\n")
            end
        end
    end
end)

RegisterServerEvent('fw-admin:server:banPlayer')
AddEventHandler('fw-admin:server:banPlayer', function(playerId, Reason)
    local src = source
    local BanId = 'BAN-'..math.random(11111,99999)
    if Framework.Functions.HasPermission(src, permissions["ban"]) then
        Framework.Functions.ExecuteSql(false, "INSERT INTO `server_bans` (`banid`, `name`, `steam`, `license`, `reason`, `bannedby`) VALUES ('"..BanId.."', '"..GetPlayerName(playerId).."', '"..GetPlayerIdentifiers(playerId)[1].."', '"..GetPlayerIdentifiers(playerId)[2].."', '"..Reason.."', '"..GetPlayerName(src).."')")
        TriggerEvent("fw-logs:server:SendLog", "bans", "Verbannen", "green", "**Speler:** "..GetPlayerName(playerId).." \n**Reden:** " ..Reason.. "\n **Ban ID:** "..BanId.."\n**Door:** "..GetPlayerName(src))
        DropPlayer(playerId, "\nš° Je bent verbannen van de server. \nš Reden: " ..Reason.. '\nš Ban ID: '..BanId..'\nš Verbannen Door: ' ..GetPlayerName(source).. '\n\n Voor een unban kan je een ticket openen in de discord.')
    end      
end)

Framework.Commands.Add("announce", "Gį»­i thĆ“ng bĆ”o toĆ n server", {}, false, function(source, args)
    local msg = table.concat(args, " ")
    for i = 1, 3, 1 do
        TriggerClientEvent('chatMessage', -1, "SYSTEM", "error", msg)
    end
end, "admin")

Framework.Commands.Add("admin", "Mį» menu admin", {}, false, function(source, args)
    local group = Framework.Functions.GetPermission(source)
    TriggerClientEvent('fw-admin:client:openMenu', source, group)
end, "admin")

Framework.Commands.Add("report", "Gį»­i bĆ”o cĆ”o cho Admin (Chį» gį»­i khi cįŗ§n thiįŗæt!)", {{name="noi_dung", help="Nhįŗ­p nį»i dung"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    local Player = Framework.Functions.GetPlayer(source)
    TriggerClientEvent('fw-admin:client:SendReport', -1, GetPlayerName(source), source, msg)
    TriggerClientEvent('chatMessage', source, "REPORT VERSTUURD", "normal", msg)
    TriggerEvent("ec-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {message=msg})
end)

Framework.Commands.Add("s", "Gį»­i tin nhįŗÆn cho tįŗ„t cįŗ£ admin", {{name="noi_dung", help="Nhįŗ­p nį»i dung"}}, true, function(source, args)
    local msg = table.concat(args, " ")
    TriggerClientEvent('fw-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

Framework.Commands.Add("reportr", "Trįŗ£ lį»i bĆ”o cĆ”o - Admin", {}, false, function(source, args)
    local playerId = tonumber(args[1])
    table.remove(args, 1)
    local msg = table.concat(args, " ")
    local OtherPlayer = Framework.Functions.GetPlayer(playerId)
    local Player = Framework.Functions.GetPlayer(source)
    if OtherPlayer ~= nil then
        TriggerClientEvent('chatMessage', playerId, "ADMIN - "..GetPlayerName(source), "reportr", msg)
        TriggerClientEvent('Framework:Notify', source, "ÄĆ£ phįŗ£n hį»i")
        TriggerEvent("ec-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {otherCitizenId=OtherPlayer.PlayerData.citizenid, message=msg})
        for k, v in pairs(Framework.Functions.GetPlayers()) do
            if Framework.Functions.HasPermission(v, "admin") then
                if Framework.Functions.IsOptin(v) then
                    TriggerClientEvent('chatMessage', v, "ReportReply("..source..") - "..GetPlayerName(source), "reportr", msg)
                end
            end
        end
    else
        TriggerClientEvent('Framework:Notify', source, "Persoon is niet online", "error")
    end
end, "admin")

Framework.Commands.Add("reporttoggle", "Bįŗ­t/TįŗÆt nhįŗ­n bĆ”o cĆ”o", {}, false, function(source, args)
    Framework.Functions.ToggleOptin(source)
    if Framework.Functions.IsOptin(source) then
        TriggerClientEvent('Framework:Notify', source, "Bįŗ­t nhįŗ­n bĆ”o cĆ”o", "success")
    else
        TriggerClientEvent('Framework:Notify', source, "Tįŗ®T nhįŗ­n bĆ”o cĆ”o", "error")
    end
end, "admin")

Framework.Commands.Add("unban", "Unban ngĘ°į»i chĘ”i", {{name="Banid", help="BanId cį»§a ngĘ°į»i chĘ”i"}}, true, function(source, args)
    local src = source
    local BanID = args[1]
    if BanID ~= nil then
        Framework.Functions.ExecuteSql(false, "SELECT * FROM `server_bans` WHERE `banid` = '"..BanID.."'", function(result)
            if result[1] ~= nil then 
                Framework.Functions.ExecuteSql(false, "DELETE FROM `server_bans` WHERE `banid` = '"..BanID.."'")
                TriggerEvent("fw-logs:server:SendLog", "bans", "Unban", "red", "**BanId:** "..BanID.." \n**Status:** Unbanned. \n**Door:** "..GetPlayerName(src))
                TriggerClientEvent('chat:addMessage', src, {
                    template = '<div class="chat-message error"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Ban ID:</strong> {1} <br><strong>Status:</strong> {2} <br><strong>Unbanned Door:</strong> {3} </div></div>',
                    args = {'Unban Info', BanID, 'Lį»nh cįŗ„m ÄĆ£ bį» thu hį»i', GetPlayerName(src)}
                })
            else
                TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Geen bans gevonden op dit id')
            end
        end)
    else 
        TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Geef een ban id op..')
    end
end, "admin")

Framework.Commands.Add("baninfo", "Xem thĆ“ng tin ban cį»§a ngĘ°į»i chĘ”i", {{name="BanId", help="BanId cį»§a ngĘ°į»i chĘ”i"}}, true, function(source, args)
    local src = source
    local BanId = args[1]
    if BanId ~= nil then
        Framework.Functions.ExecuteSql(true, "SELECT * FROM `server_bans` WHERE `banid` = '"..BanId.."'", function(result)
            if result[1] ~= nil then 
                local Info = result[1].reason
                local bannedby = result[1].bannedby
                local bannedplayername = result[1].name
                TriggerClientEvent('chat:addMessage', src, {
                    template = '<div class="chat-message error"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Speler:</strong> {1} <br><strong>Ban ID:</strong> {2} <br><strong>Ban Reden:</strong> {3} <br><strong>Verbannen Door:</strong> {4} <br><strong>Notitie:</strong> {5} </div></div>',
                    args = {'Ban Info', bannedplayername, BanId, Info, bannedby, '/unban ' ..BanId.. ' | Nįŗæu bįŗ”n muį»n bį» cįŗ„m ngĘ°į»i chĘ”i nĆ y'}
                })
            else
            TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'KhĆ“ng tĆ¬m thįŗ„y BanId')
            end
        end)
    else 
    TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Vui lĆ²ng nhįŗ­p BanId..')
    end
end, "admin")

RegisterCommand("kickall", function(source, args, rawCommand)
    local src = source
    if src > 0 then
        local reason = table.concat(args, ' ')
        local Player = Framework.Functions.GetPlayer(src)
        if Framework.Functions.HasPermission(src, "god") then
            if args[1] ~= nil then
                for k, v in pairs(Framework.Functions.GetPlayers()) do
                    local Player = Framework.Functions.GetPlayer(v)
                    if Player ~= nil then 
                        DropPlayer(Player.PlayerData.source, reason)
                    end
                end
            else
                TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Vui lĆ²ng nhįŗ­p lĆ½ do..')
            end
        else
            TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'KhĆ“ng Äį»§ quyį»n hįŗ”n..')
        end
    else
        for k, v in pairs(Framework.Functions.GetPlayers()) do
            local Player = Framework.Functions.GetPlayer(v)
            if Player ~= nil then 
                DropPlayer(Player.PlayerData.source, "Khį»i Äį»ng lįŗ”i mĆ”y chį»§, vui lĆ²ng chį» trong giĆ¢y lĆ”t!")
            end
        end
    end
end, false)

RegisterServerEvent('fw-admin:server:bringTp')
AddEventHandler('fw-admin:server:bringTp', function(targetId, coords)
    TriggerClientEvent('fw-admin:client:bringTp', targetId, coords)
end)

Framework.Functions.CreateCallback('fw-admin:server:hasPermissions', function(source, cb, group)
    local src = source
    local retval = false
    if Framework.Functions.HasPermission(src, group) then
        retval = true
    end
    cb(retval)
end)

RegisterServerEvent('fw-admin:server:setPermissions')
AddEventHandler('fw-admin:server:setPermissions', function(targetId, group)
    Framework.Functions.AddPermission(targetId, group.rank)
    TriggerClientEvent('Framework:Notify', targetId, 'ÄĆ£ set permission thĆ nh cĆ“ng '..group.label)
end)

RegisterServerEvent('fw-admin:server:OpenSkinMenu')
AddEventHandler('fw-admin:server:OpenSkinMenu', function(targetId)
    TriggerClientEvent("fw-clothing:client:openMenu", targetId)
end)

RegisterServerEvent('fw-admin:server:SendReport')
AddEventHandler('fw-admin:server:SendReport', function(name, targetSrc, msg)
    local src = source
    local Players = Framework.Functions.GetPlayers()
    if Framework.Functions.HasPermission(src, "admin") then
        if Framework.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "REPORT - "..name.." ("..targetSrc..")", "report", msg)
        end
    end
end)

RegisterServerEvent('fw-admin:server:StaffChatMessage')
AddEventHandler('fw-admin:server:StaffChatMessage', function(name, msg)
    local src = source
    local Players = Framework.Functions.GetPlayers()

    if Framework.Functions.HasPermission(src, "admin") then
        if Framework.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "STAFFCHAT - "..name, "error", msg)
        end
    end
end)