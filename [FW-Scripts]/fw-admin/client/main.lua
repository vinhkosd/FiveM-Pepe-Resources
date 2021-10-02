local myPermissionRank = nil

Framework = nil

-- Code

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
     Citizen.Wait(250)
     TriggerServerEvent("fw-admin:server:loadPermissions")
     isLoggedIn = true
 end)
end)

RegisterNetEvent('fw-admin:client:openMenu')
AddEventHandler('fw-admin:client:openMenu', function(group)
 WarMenu.OpenMenu('admin')
 myPermissionRank = group
end)

Admin = {}
Admin.Functions = {}
in_noclip_mode = false
local isNoclip = false
local isFreeze = false
local isSpectating = false
local showNames = false
local showBlips = false
local isInvisible = false
local deleteLazer = false
local hasGodmode = false
local hasDev = false
local lastSpectateCoord = nil
local NoclipDev = true
local currentPlayerMenu = nil
local currentPlayer = 0
local currentBanIndex = 1
local selectedBanIndex = 1
local currentPermIndex = 1
local selectedPermIndex = 1

local Actions = {
 'Kick',
 'Ban',
}

local Action = {
 'Kick',
 'Ban',
}

local menus = {
 "admin",
 "playerMan",
 "serverMan",
 currentPlayer,
 "playerOptions",
 "teleportOptions",
 "permissionOptions",
 "weatherOptions",
 "adminOptions",
 "adminOpt",
 "selfOptions",
 "polyzone",
}

local times = {
 "00:00",
 "01:00",
 "02:00",
 "03:00",
 "04:00",
 "05:00",
 "06:00",
 "07:00",
 "08:00",
 "09:00",
 "10:00",
 "11:00",
 "12:00",
 "13:00",
 "14:00",
 "15:00",
 "16:00",
 "17:00",
 "18:00",
 "19:00",
 "20:00",
 "21:00",
 "22:00",
 "23:00",
}

local ServerTimes = {
    [1] = {hour = 0, minute = 0},
    [2] = {hour = 1, minute = 0},
    [3] = {hour = 2, minute = 0},
    [4] = {hour = 3, minute = 0},
    [5] = {hour = 4, minute = 0},
    [6] = {hour = 5, minute = 0},
    [7] = {hour = 6, minute = 0},
    [8] = {hour = 7, minute = 0},
    [9] = {hour = 8, minute = 0},
    [10] = {hour = 9, minute = 0},
    [11] = {hour = 10, minute = 0},
    [12] = {hour = 11, minute = 0},
    [13] = {hour = 12, minute = 0},
    [14] = {hour = 13, minute = 0},
    [15] = {hour = 14, minute = 0},
    [16] = {hour = 15, minute = 0},
    [17] = {hour = 16, minute = 0},
    [18] = {hour = 17, minute = 0},
    [19] = {hour = 18, minute = 0},
    [20] = {hour = 19, minute = 0},
    [21] = {hour = 20, minute = 0},
    [22] = {hour = 21, minute = 0},
    [23] = {hour = 22, minute = 0},
    [24] = {hour = 23, minute = 0},
}

local perms = {
 "User",
 "Admin",
 "God"
}

local AvailableWeatherTypes = {
 {label = "Extra Sunny",         weather = 'EXTRASUNNY',}, 
 {label = "Clear",               weather = 'CLEAR',}, 
 {label = "Neutral",             weather = 'NEUTRAL',}, 
 {label = "Smog",                weather = 'SMOG',}, 
 {label = "Foggy",               weather = 'FOGGY',}, 
 {label = "Overcast",            weather = 'OVERCAST',}, 
 {label = "Clouds",              weather = 'CLOUDS',}, 
 {label = "Clearing",            weather = 'CLEARING',}, 
 {label = "Rain",                weather = 'RAIN',}, 
 {label = "Thunder",             weather = 'THUNDER',}, 
 {label = "Snow",                weather = 'SNOW',}, 
 {label = "Blizzard",            weather = 'BLIZZARD',}, 
 {label = "Snowlight",           weather = 'SNOWLIGHT',}, 
 {label = "XMAS (Heavy Snow)",   weather = 'XMAS',}, 
 {label = "Halloween (Scarry)",  weather = 'HALLOWEEN',},
}

local PermissionLevels = {
 [1] = {rank = "user", label = "User"},
 [2] = {rank = "admin", label = "Admin"},
 [3] = {rank = "god", label = "God"},
}

Citizen.CreateThread(function()
RegisterFontFile('arial')
WarMenu.CreateMenu('admin', '~b~Admin Menu')
WarMenu.CreateSubMenu('playerMan', 'admin')
WarMenu.CreateSubMenu('serverMan', 'admin')
WarMenu.CreateSubMenu('adminOpt', 'admin')
WarMenu.CreateSubMenu('selfOptions', 'adminOpt')
--WarMenu.CreateSubMenu('polyzone', 'serverMan')
WarMenu.CreateSubMenu('weatherOptions', 'serverMan')
for k, v in pairs(menus) do
    WarMenu.SetMenuX(v, 0.71)
    WarMenu.SetMenuY(v, 0.15)
    WarMenu.SetMenuWidth(v, 0.23)
    WarMenu.SetTitleColor(v, 255, 255, 255, 255)
    WarMenu.SetTitleBackgroundColor(v, 0, 0, 0, 111)
end
while true do
    if WarMenu.IsMenuOpened('admin') then
        WarMenu.MenuButton('Quản lý Admin', 'adminOpt')
        WarMenu.MenuButton('Quản lý người chơi', 'playerMan')
        WarMenu.MenuButton('Quản lý server', 'serverMan')
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('adminOpt') then
        WarMenu.MenuButton('Tùy chọn người chơi (~g~'..GetPlayerName(PlayerId())..'~s~)', 'selfOptions')
        WarMenu.CheckBox("Hiện tên người chơi", showNames, function(checked) showNames = checked end)
         if WarMenu.CheckBox("Hiện trên map", showBlips, function(checked) showBlips = checked end) then
             toggleBlips()
         end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('selfOptions') then
        if WarMenu.CheckBox("Noclip", isNoclip, function(checked) isNoclip = checked end) then
            local target = PlayerId()
            local targetId = GetPlayerServerId(target)
            TriggerServerEvent("fw-admin:server:togglePlayerNoclip", targetId)
        end
        if WarMenu.Button('Revive') then
            local target = PlayerId()
            local targetId = GetPlayerServerId(target)
            TriggerEvent('fw-hospital:client:revive')
        end
        if WarMenu.CheckBox("Vô hình", isInvisible, function(checked) isInvisible = checked end) then
            local myPed = GetPlayerPed(-1)
            
            if isInvisible then
                SetEntityVisible(myPed, false, false)
            else
                SetEntityVisible(myPed, true, false)
            end
        end
        if WarMenu.CheckBox("Godmode", hasGodmode, function(checked) hasGodmode = checked end) then
            local myPlayer = PlayerId()
            
            SetPlayerInvincible(myPlayer, hasGodmode)
        end
        if WarMenu.CheckBox("Chế độ nhà phát triển", hasDev, function(checked) hasDev = checked end) then
            local myPlayer = PlayerId()
            ToggleDev(hasDev)
        end
        if WarMenu.CheckBox("Súng Laze phá hủy", deleteLazer, function(checked) deleteLazer = checked end) then
        end
        
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('playerMan') then
        local players = getPlayers()
        for k, v in pairs(players) do
            WarMenu.CreateSubMenu(v["id"], 'playerMan', v["serverid"].." | "..v["name"])
        end
        if WarMenu.MenuButton('#'..GetPlayerServerId(PlayerId()).." | "..GetPlayerName(PlayerId()), PlayerId()) then
            currentPlayer = PlayerId()
            if WarMenu.CreateSubMenu('playerOptions', currentPlayer) then
                currentPlayerMenu = 'playerOptions'
            elseif WarMenu.CreateSubMenu('teleportOptions', currentPlayer) then
                currentPlayerMenu = 'teleportOptions'
            elseif WarMenu.CreateSubMenu('adminOptions', currentPlayer) then
                currentPlayerMenu = 'adminOptions'
            end
            if myPermissionRank == "god" then
                if WarMenu.CreateSubMenu('permissionOptions', currentPlayer) then
                    currentPlayerMenu = 'permissionOptions'
                end
            end
        end
        for k, v in pairs(players) do
            if v["id"] ~= PlayerId() then
                if WarMenu.MenuButton('#'..v["serverid"].." | "..v["name"], v["id"]) then
                    currentPlayer = v["id"]
                    if WarMenu.CreateSubMenu('playerOptions', currentPlayer) then
                        currentPlayerMenu = 'playerOptions'
                    elseif WarMenu.CreateSubMenu('teleportOptions', currentPlayer) then
                        currentPlayerMenu = 'teleportOptions'
                    elseif WarMenu.CreateSubMenu('adminOptions', currentPlayer) then
                        currentPlayerMenu = 'adminOptions'
                    end
                end
            end
        end
        if myPermissionRank == "god" then
            if WarMenu.CreateSubMenu('permissionOptions', currentPlayer) then
                currentPlayerMenu = 'permissionOptions'
            end
        end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('serverMan') then
        WarMenu.MenuButton('Thời tiết', 'weatherOptions')
        WarMenu.MenuButton('Polyzones', 'polyzone')
        if WarMenu.ComboBox('Server Tijd', times, currentBanIndex, selectedBanIndex, function(currentIndex, selectedIndex)
            currentBanIndex = currentIndex
            selectedBanIndex = selectedIndex
        end) then
            local time = ServerTimes[currentBanIndex]
            TriggerServerEvent("fw-weathersync:server:setTime", time.hour, time.minute)
        end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened(currentPlayer) then
        WarMenu.MenuButton('Tùy chọn người chơi (~g~'..GetPlayerName(currentPlayer)..'~s~)', 'playerOptions')
        WarMenu.MenuButton('Teleport', 'teleportOptions')
        WarMenu.MenuButton('Tùy chọn Admin', 'adminOptions')
        if myPermissionRank == "god" then
            WarMenu.MenuButton('Permission', 'permissionOptions')
        end
        
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('playerOptions') then
        if WarMenu.MenuButton('Kill', currentPlayer) then
            TriggerServerEvent("fw-admin:server:killPlayer", GetPlayerServerId(currentPlayer))
        end
        if WarMenu.MenuButton('Revive', currentPlayer) then
            local target = GetPlayerServerId(currentPlayer)
            TriggerServerEvent('fw-hospital:server:revive:player', target)
        end
        if WarMenu.CheckBox("Noclip", isNoclip, function(checked) isNoclip = checked end) then
            local target = GetPlayerServerId(currentPlayer)
            TriggerServerEvent("fw-admin:server:togglePlayerNoclip", target)
        end
        if WarMenu.CheckBox("Freeze", isFreeze, function(checked) isFreeze = checked end) then
            local target = GetPlayerServerId(currentPlayer)
            TriggerServerEvent("fw-admin:server:Freeze", target, isFreeze)
        end
         if WarMenu.CheckBox("Spectate", isSpectating, function(checked) isSpectating = checked end) then
             local target = GetPlayerFromServerId(GetPlayerServerId(currentPlayer))
             local targetPed = GetPlayerPed(target)
             local targetCoords = GetEntityCoords(targetPed)
             SpectatePlayer(targetPed, isSpectating)
         end
        if WarMenu.MenuButton("Open Inventory", currentPlayer) then
            local targetId = GetPlayerServerId(currentPlayer)
            OpenTargetInventory(targetId)
        end
        if WarMenu.MenuButton("Geef Kleding Menu", currentPlayer) then
            local targetId = GetPlayerServerId(currentPlayer)
            TriggerServerEvent('fw-admin:server:OpenSkinMenu', targetId)
        end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('teleportOptions') then
        if WarMenu.MenuButton('Teleport đến người chơi', currentPlayer) then
            local target = GetPlayerPed(currentPlayer)
            local ply = GetPlayerPed(-1)
            if in_noclip_mode then
                turnNoClipOff()
                SetEntityCoords(ply, GetEntityCoords(target))
                turnNoClipOn()
            else
                SetEntityCoords(ply, GetEntityCoords(target))
            end
        end
        if WarMenu.MenuButton('Teleport người chơi', currentPlayer) then
            local target = GetPlayerPed(currentPlayer)
            local plyCoords = GetEntityCoords(GetPlayerPed(-1))
            TriggerServerEvent('fw-admin:server:bringTp', GetPlayerServerId(currentPlayer), plyCoords)
        end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('permissionOptions') then
        if WarMenu.ComboBox('Permission Group', perms, currentPermIndex, selectedPermIndex, function(currentIndex, selectedIndex)
            currentPermIndex = currentIndex
            selectedPermIndex = selectedIndex
        end) then
            local group = PermissionLevels[currentPermIndex]
            local target = GetPlayerServerId(currentPlayer)
            TriggerServerEvent('fw-admin:server:setPermissions', target, group)
            Framework.Functions.Notify('Je hebt '..GetPlayerName(currentPlayer)..'\'s groep is veranderd naar '..group.label)
        end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('adminOptions') then
        if WarMenu.ComboBox('Server Actie', Actions, currentBanIndex, selectedBanIndex, function(currentIndex, selectedIndex)
            currentBanIndex = currentIndex
            selectedBanIndex = selectedIndex
        end) then
            local Action = Actions[currentBanIndex]
            if Action == 'Ban' then
                DisplayOnscreenKeyboard(1, "", "", "", "", "", "", 128 + 1)
                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                    Citizen.Wait(7)
                end
                local Reden = GetOnscreenKeyboardResult()
                if Reden ~= nil and Reden ~= "" then
                    local Target = GetPlayerServerId(currentPlayer)
                    TriggerServerEvent('fw-admin:server:banPlayer', Target, Reden)
                end
            elseif Action == 'Kick' then
                DisplayOnscreenKeyboard(1, "", "", "", "", "", "", 128 + 1)
                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                    Citizen.Wait(7)
                end
                local Reden = GetOnscreenKeyboardResult()
                if Reden ~= nil and Reden ~= "" then
                    local Target = GetPlayerServerId(currentPlayer)
                    TriggerServerEvent('fw-admin:server:kickPlayer', Target, Reden)
                end
            end
        end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('polyzone') then
            if WarMenu.MenuButton('Create Poly Zone', 'polyzone') then
            end
        WarMenu.Display()
    elseif WarMenu.IsMenuOpened('weatherOptions') then
        for k, v in pairs(AvailableWeatherTypes) do
            if WarMenu.MenuButton(AvailableWeatherTypes[k].label, 'weatherOptions') then
                TriggerServerEvent('fw-weathersync:server:setWeather', AvailableWeatherTypes[k].weather)
                Framework.Functions.Notify('Thời tiết đã thay đổi thành: '..AvailableWeatherTypes[k].label)
            end
        end
        WarMenu.Display()
    end
    Citizen.Wait(3)
    end
end)

-- // Troep \\ --

function SpectatePlayer(targetPed, toggle)
    local myPed = GetPlayerPed(-1)
    if toggle then
        showNames = true
        SetEntityVisible(myPed, false)
        SetEntityInvincible(myPed, true)
        lastSpectateCoord = GetEntityCoords(myPed)
        DoScreenFadeOut(150)
        SetTimeout(250, function()
            SetEntityVisible(myPed, false)
            SetEntityCoords(myPed, GetOffsetFromEntityInWorldCoords(targetPed, 0.0, 0.45, 0.0))
            AttachEntityToEntity(myPed, targetPed, 11816, 0.0, -1.3, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            SetEntityVisible(myPed, false)
            SetEntityInvincible(myPed, true)
            DoScreenFadeIn(150)
        end)
    else
        showNames = false
        DoScreenFadeOut(150)
        DetachEntity(myPed, true, false)
        SetTimeout(250, function()
            SetEntityCoords(myPed, lastSpectateCoord)
            SetEntityVisible(myPed, true)
            SetEntityInvincible(myPed, false)
            DoScreenFadeIn(150)
            lastSpectateCoord = nil
        end)
    end
end

function OpenTargetInventory(targetId)
 WarMenu.CloseMenu()
 TriggerServerEvent("fw-inventory:server:OpenInventory", "otherplayer", targetId)
end

Citizen.CreateThread(function()
while true do
    if showNames then
        for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(GetPlayerPed(-1)), 5.0)) do
            local PlayerId = GetPlayerServerId(player)
            local PlayerPed = GetPlayerPed(player)
            local PlayerName = GetPlayerName(player)
            local PlayerCoords = GetEntityCoords(PlayerPed)
            DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.0, '[~g~'..PlayerId..'~s~] '..PlayerName)
        end
    else
        Citizen.Wait(1000)
    end
    Citizen.Wait(3)
    end
end)

local PlayerBlips = {}

function toggleBlips()
 Citizen.CreateThread(function()
     -- while true do 
         if showBlips then
             local Players = getPlayers() 
             for k, v in pairs(Players) do
                 local PlayerPed = v["ped"]
                 local playerName = v["name"] 
                 RemoveBlip(PlayerBlips[k]) 
                 local PlayerBlip = AddBlipForEntity(PlayerPed) 
                 SetBlipSprite(PlayerBlip, 1)
                 SetBlipColour(PlayerBlip, 0)
                 SetBlipScale  (PlayerBlip, 0.75)
                 SetBlipAsShortRange(PlayerBlip, true)
                 BeginTextCommandSetBlipName("STRING")
                 AddTextComponentString('['..v["serverid"]..'] '..playerName)
                 EndTextCommandSetBlipName(PlayerBlip)
                 PlayerBlips[k] = PlayerBlip
             end
         else
             if next(PlayerBlips) ~= nil then
                 for k, v in pairs(PlayerBlips) do
                     RemoveBlip(PlayerBlips[k])
                 end
                 PlayerBlips = {}
             end
             Citizen.Wait(1000)
         end
 end)
end

Citizen.CreateThread(function()
 while true do
     if showBlips then
         if next(PlayerBlips) ~= nil then
             for k, v in pairs(PlayerBlips) do
                 RemoveBlip(PlayerBlips[k])
             end
             PlayerBlips = {}
         end
         local Players = getPlayers()
         for k, v in pairs(Players) do
             local PlayerPed = v["ped"]
             local playerName = v["name"] 
             RemoveBlip(PlayerBlips[k]) 
             local PlayerBlip = AddBlipForEntity(PlayerPed) 
             SetBlipSprite(PlayerBlip, 1)
             SetBlipColour(PlayerBlip, 0)
             SetBlipScale  (PlayerBlip, 0.75)
             SetBlipAsShortRange(PlayerBlip, true)
             BeginTextCommandSetBlipName("STRING")
             AddTextComponentString('['..v["serverid"]..'] '..playerName)
             EndTextCommandSetBlipName(PlayerBlip)
             PlayerBlips[k] = PlayerBlip
         end 
         print('blip updated!')
     else
         if next(PlayerBlips) ~= nil then
             for k, v in pairs(PlayerBlips) do
                 RemoveBlip(PlayerBlips[k])
             end
             PlayerBlips = {}
         end
     end 
     Citizen.Wait(30000)
 end
end)

Citizen.CreateThread(function()	
 while true do
 	Citizen.Wait(0) 
     if deleteLazer then
         local color = {r = 255, g = 255, b = 255, a = 200}
         local position = GetEntityCoords(GetPlayerPed(-1))
         local hit, coords, entity = RayCastGamePlayCamera(1000.0)
         
         -- If entity is found then verifie entity
         if hit and (IsEntityAVehicle(entity) or IsEntityAPed(entity) or IsEntityAnObject(entity)) then
             local entityCoord = GetEntityCoords(entity)
             local minimum, maximum = GetModelDimensions(GetEntityModel(entity))
             
             DrawEntityBoundingBox(entity, color)
             DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
             DrawText3D(entityCoord.x, entityCoord.y, entityCoord.z, "Obj: " .. entity .. " Model: " .. GetEntityModel(entity).. " \nDruk [~g~E~s~] để xóa vật thể!", 2) 
             -- When E pressed then remove targeted entity
             if IsControlJustReleased(0, 38) then
                 -- Set as missionEntity so the object can be remove (Even map objects)
                 SetEntityAsMissionEntity(entity, true, true)
                 SetEntityAsNoLongerNeeded(entity)
                 DeleteEntity(entity)
             end
         -- Only draw of not center of map
         elseif coords.x ~= 0.0 and coords.y ~= 0.0 then
             -- Draws line to targeted position
             DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
             DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, color.r, color.g, color.b, color.a, false, true, 2, nil, nil, false)
         end
     else
         Citizen.Wait(1000)
     end
 end
end)

-- Draws boundingbox around the object with given color parms
function DrawEntityBoundingBox(entity, color)
 local model = GetEntityModel(entity)
 local min, max = GetModelDimensions(model)
 local rightVector, forwardVector, upVector, position = GetEntityMatrix(entity) 
 -- Calculate size
 local dim = 
 { 
 	x = 0.5*(max.x - min.x), 
 	y = 0.5*(max.y - min.y), 
 	z = 0.5*(max.z - min.z)
 } 
 local FUR = 
 {
 	x = position.x + dim.y*rightVector.x + dim.x*forwardVector.x + dim.z*upVector.x, 
 	y = position.y + dim.y*rightVector.y + dim.x*forwardVector.y + dim.z*upVector.y, 
 	z = 0
 } 
 local FUR_bool, FUR_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
 FUR.z = FUR_z
 FUR.z = FUR.z + 2 * dim.z 
 local BLL = 
 {
     x = position.x - dim.y*rightVector.x - dim.x*forwardVector.x - dim.z*upVector.x,
     y = position.y - dim.y*rightVector.y - dim.x*forwardVector.y - dim.z*upVector.y,
     z = 0
 }
 local BLL_bool, BLL_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
 BLL.z = BLL_z 
 -- DEBUG
 local edge1 = BLL
 local edge5 = FUR 
 local edge2 = 
 {
     x = edge1.x + 2 * dim.y*rightVector.x,
     y = edge1.y + 2 * dim.y*rightVector.y,
     z = edge1.z + 2 * dim.y*rightVector.z
 } 
 local edge3 = 
 {
     x = edge2.x + 2 * dim.z*upVector.x,
     y = edge2.y + 2 * dim.z*upVector.y,
     z = edge2.z + 2 * dim.z*upVector.z
 } 
 local edge4 = 
 {
     x = edge1.x + 2 * dim.z*upVector.x,
     y = edge1.y + 2 * dim.z*upVector.y,
     z = edge1.z + 2 * dim.z*upVector.z
 } 
 local edge6 = 
 {
     x = edge5.x - 2 * dim.y*rightVector.x,
     y = edge5.y - 2 * dim.y*rightVector.y,
     z = edge5.z - 2 * dim.y*rightVector.z
 } 
 local edge7 = 
 {
     x = edge6.x - 2 * dim.z*upVector.x,
     y = edge6.y - 2 * dim.z*upVector.y,
     z = edge6.z - 2 * dim.z*upVector.z
 } 
 local edge8 = 
 {
     x = edge5.x - 2 * dim.z*upVector.x,
     y = edge5.y - 2 * dim.z*upVector.y,
     z = edge5.z - 2 * dim.z*upVector.z
 } 
 DrawLine(edge1.x, edge1.y, edge1.z, edge2.x, edge2.y, edge2.z, color.r, color.g, color.b, color.a)
 DrawLine(edge1.x, edge1.y, edge1.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
 DrawLine(edge2.x, edge2.y, edge2.z, edge3.x, edge3.y, edge3.z, color.r, color.g, color.b, color.a)
 DrawLine(edge3.x, edge3.y, edge3.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
 DrawLine(edge5.x, edge5.y, edge5.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
 DrawLine(edge5.x, edge5.y, edge5.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
 DrawLine(edge6.x, edge6.y, edge6.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
 DrawLine(edge7.x, edge7.y, edge7.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
 DrawLine(edge1.x, edge1.y, edge1.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
 DrawLine(edge2.x, edge2.y, edge2.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
 DrawLine(edge3.x, edge3.y, edge3.z, edge5.x, edge5.y, edge5.z, color.r, color.g, color.b, color.a)
 DrawLine(edge4.x, edge4.y, edge4.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
end

-- Embed direction in rotation vector
function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

-- Raycast function for "Admin Lazer"
function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = 
	{ 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance 
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

RegisterNetEvent('fw-admin:client:bringTp')
AddEventHandler('fw-admin:client:bringTp', function(coords)
    local ped = GetPlayerPed(-1)
    SetEntityCoords(ped, coords.x, coords.y, coords.z)
end)

RegisterNetEvent('fw-admin:client:Freeze')
AddEventHandler('fw-admin:client:Freeze', function(toggle)
    local ped = GetPlayerPed(-1)

    local veh = GetVehiclePedIsIn(ped)

    if veh ~= 0 then
        FreezeEntityPosition(ped, toggle)
        FreezeEntityPosition(veh, toggle)
    else
        FreezeEntityPosition(ped, toggle)
    end
end)

RegisterNetEvent('fw-admin:client:SendReport')
AddEventHandler('fw-admin:client:SendReport', function(name, src, msg)
    TriggerServerEvent('fw-admin:server:SendReport', name, src, msg)
end)

RegisterNetEvent('fw-admin:client:SendStaffChat')
AddEventHandler('fw-admin:client:SendStaffChat', function(name, msg)
    TriggerServerEvent('fw-admin:server:StaffChatMessage', name, msg)
end)

RegisterNetEvent('fw-admin:client:SetWeaponAmmoManual')
AddEventHandler('fw-admin:client:SetWeaponAmmoManual', function(ammo)
    local ped = GetPlayerPed(-1)
        local weapon = GetSelectedPedWeapon(ped)
        if weapon ~= nil then
            SetPedAmmo(ped, weapon, tonumber(ammo))
            Framework.Functions.Notify('+' ..tonumber(ammo).. ' đạn cho súng '..Framework.Shared.Weapons[weapon]["label"], 'success')
        else
            Framework.Functions.Notify('Bạn không cầm vũ khí..', 'error')
        end
end)

function ToggleDev(status)
    local myPlayer = PlayerId()
    if status then
        TriggerEvent('ec-hud:clinet:set:mode', status)
        SetPlayerInvincible(myPlayer, status)
        TriggerServerEvent('fw-admin:server:debugtool')
        Framework.Functions.Notify('Chế độ phát triển đang bật', 'success')
    else
        TriggerEvent('ec-hud:clinet:set:mode', status)
        SetPlayerInvincible(myPlayer, status)
        TriggerServerEvent('fw-admin:server:debugtool')
        Framework.Functions.Notify('Chế độ phát triển đang tắt', 'error')
    end
end

DrawText3D = function(x, y, z, text, lines)
    if lines == nil then
        lines = 1
    end
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125 * lines, 0.017+ factor, 0.03 * lines, 0, 0, 0, 75)
    ClearDrawOrigin()
end

GetPlayers = function()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            table.insert(players, player)
        end
    end
    return players
end

GetPlayersFromCoords = function(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}
    if coords == nil then
		coords = GetEntityCoords(GetPlayerPed(-1))
    end
    if distance == nil then
        distance = 5.0
    end
    for _, player in pairs(players) do
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
		if targetdistance <= distance then
			table.insert(closePlayers, player)
		end
    end
    return closePlayers
end

function getPlayers()
    players = {}
    for _, player in ipairs(GetActivePlayers()) do
        table.insert(players, {
            ['ped'] = GetPlayerPed(player),
            ['name'] = GetPlayerName(player),
            ['id'] = player,
            ['serverid'] = GetPlayerServerId(player),
        })
    end
    return players
end

Citizen.CreateThread(function()
local Id = GetPlayerServerId(PlayerId())
while true do
    Citizen.Wait(1)
    if hasDev == true then
        if IsControlJustPressed(0, 27) then
            TriggerServerEvent("fw-admin:server:togglePlayerNoclip", Id)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        if isSpectating and IsEntityVisible(GetPlayerPed(-1)) == 1 then
        SetEntityVisible(GetPlayerPed(-1), false, false)
        end
    end
end)