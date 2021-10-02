Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('fw-cityhall:server:requestId')
AddEventHandler('fw-cityhall:server:requestId', function(identityData)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local licenses = {
        ["driver"] = true,
    }
    local info = {}
    if identityData.item == "id-card" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
    elseif identityData.item == "drive-card" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = "A1-A2-A | AM-B | C1-C-CE"
    end
    Player.Functions.AddItem(identityData.item, 1, false, info)
    TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items[identityData.item], 'add')
end)

RegisterServerEvent('fw-cityhall:server:ApplyJob')
AddEventHandler('fw-cityhall:server:ApplyJob', function(job)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local JobInfo = Framework.Shared.Jobs[job]

    Player.Functions.SetJob(job)

    TriggerClientEvent('Framework:Notify', src, 'Gefeliciteerd met je nieuwe baan! ('..JobInfo.label..')')
end)