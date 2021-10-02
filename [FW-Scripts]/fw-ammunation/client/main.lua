    Framework = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if Framework == nil then
            TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

local robberyAlert = false
local isLoggedIn = false
local firstAlarm = false

function DrawText3Ds(x, y, z, text)
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
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        inRange = false

        if Framework ~= nil then
            if isLoggedIn then
                PlayerData = Framework.Functions.GetPlayerData()
                for case,_ in pairs(Config.Locations) do
                    -- if PlayerData.job.name ~= "police" then
                        local dist = GetDistanceBetweenCoords(pos, Config.Locations[case]["coords"]["x"], Config.Locations[case]["coords"]["y"], Config.Locations[case]["coords"]["z"])
                        local storeDist = GetDistanceBetweenCoords(pos, Config.AmmunationLocation["coords"]["x"], Config.AmmunationLocation["coords"]["y"], Config.AmmunationLocation["coords"]["z"])
                        if dist < 30 then
                            inRange = true

                            if dist < 0.6 then
                                if not Config.Locations[case]["isBusy"] and not Config.Locations[case]["isOpened"] then
                                    DrawText3Ds(Config.Locations[case]["coords"]["x"], Config.Locations[case]["coords"]["y"], Config.Locations[case]["coords"]["z"], '[E] Vitrine in slaan')
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        Framework.Functions.TriggerCallback('fw-ammunation:server:getCops', function(cops)
                                            if cops >= Config.RequiredCops then
                                                if validWeapon() then
                                                    smashVitrine(case)
                                                else
                                                    Framework.Functions.Notify('Je wapen lijkt niet sterk genoeg..', 'error')
                                                end
                                            else
                                                Framework.Functions.Notify('Er zijn niet genoeg agenten...', 'error')
                                            end                
                                        end)
                                    end
                                end
                            end

                            if storeDist < 2 then
                                if not firstAlarm then
                                    if validWeapon() then
                                        TriggerServerEvent('fw-ammunation:server:PoliceAlertMessage', "Verdachte situatie", pos, true)
                                        firstAlarm = true
                                    end
                                end
                            end
                        end
                    -- end
                end
            end
        end

        if not inRange then
            Citizen.Wait(2000)
        end

        Citizen.Wait(3)
    end
end)

function loadParticle()
	if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
    RequestNamedPtfxAsset("scr_jewelheist")
    end
    while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
    Citizen.Wait(0)
    end
    SetPtfxAssetNextCall("scr_jewelheist")
end

function loadAnimDict(dict)  
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(3)
    end
end

function validWeapon()
    local ped = GetPlayerPed(-1)
    local pedWeapon = GetSelectedPedWeapon(ped)

    for k, v in pairs(Config.WhitelistedWeapons) do
        if pedWeapon == k then
            return true
        end
    end
    return false
end

local smashing = false

function smashVitrine(k)
    local animDict = "missheist_jewel"
    local animName = "smash_case"
    local ped = GetPlayerPed(-1)
    local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.6, 0)
    local pedWeapon = GetSelectedPedWeapon(ped)

    if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
    elseif math.random(1, 100) <= 5 and IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
        Framework.Functions.Notify("Je hebt je gescheurd aan het glas..", "error")
    end

    smashing = true

    Framework.Functions.Progressbar("smash_vitrine", "Vitrine aan het inslaan..", Config.WhitelistedWeapons[pedWeapon]["timeOut"], false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('fw-ammunation:server:setVitrineState', "isOpened", true, k)
        TriggerServerEvent('fw-ammunation:server:setVitrineState', "isBusy", false, k)
        TriggerServerEvent('fw-ammunation:server:vitrineReward')
        TriggerServerEvent('fw-ammunation:server:setTimeout')
        TriggerServerEvent('fw-ammunation:server:PoliceAlertMessage', "Ammu Nation overval", plyCoords, false)
        smashing = false
        TaskPlayAnim(ped, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end, function() -- Cancel
        TriggerServerEvent('fw-ammunation:server:setVitrineState', "isBusy", false, k)
        TaskPlayAnim(ped, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end)
    TriggerServerEvent('fw-ammunation:server:setVitrineState', "isBusy", true, k)

    Citizen.CreateThread(function()
        while smashing do
            loadAnimDict(animDict)
            TaskPlayAnim(ped, animDict, animName, 3.0, 3.0, -1, 2, 0, 0, 0, 0 )
            Citizen.Wait(500)
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "breaking_vitrine_glass", 0.25)
            loadParticle()
            StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", plyCoords.x, plyCoords.y, plyCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
            Citizen.Wait(2500)
        end
    end)
end

RegisterNetEvent('fw-ammunation:client:setVitrineState')
AddEventHandler('fw-ammunation:client:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
end)

RegisterNetEvent('fw-ammunation:client:setAlertState')
AddEventHandler('fw-ammunation:client:setAlertState', function(bool)
    robberyAlert = bool
end)

RegisterNetEvent('fw-ammunation:client:PoliceAlertMessage')
AddEventHandler('fw-ammunation:client:PoliceAlertMessage', function(title, coords, blip)
    if blip then
        TriggerEvent('fw-police:client:AddPoliceAlert', {
            timeOut = 5000,
            alertTitle = title,
            details = {
                [1] = {
                    icon = '<i class="fas fa-crosshairs"></i>',
                    detail = "Ammu Nation",
                },
                [2] = {
                    icon = '<i class="fas fa-video"></i>',
                    detail = "Nvt",
                },
                [3] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = "Popular St",
                },
            },
            callSign = Framework.Functions.GetPlayerData().metadata["callsign"],
        })
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        Citizen.Wait(100)
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        Citizen.Wait(100)
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        local transG = 100
        local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0)
        SetBlipSprite(blip, 9)
        SetBlipColour(blip, 1)
        SetBlipAlpha(blip, transG)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("112 - Verdachte Situatie Ammu Nation")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    else
        if not robberyAlert then
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            TriggerEvent('fw-police:client:AddPoliceAlert', {
                timeOut = 5000,
                alertTitle = title,
                details = {
                    [1] = {
                        icon = '<i class="fas fa-crosshairs"></i>',
                        detail = "Ammu Nation",
                    },
                    [2] = {
                        icon = '<i class="fas fa-video"></i>',
                        detail = "Nvt",
                    },
                    [3] = {
                        icon = '<i class="fas fa-globe-europe"></i>',
                        detail = "Popular St",
                    },
                },
                callSign = Framework.Functions.GetPlayerData().metadata["callsign"],
            })
            robberyAlert = true
        end
    end
end)

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(GetPlayerPed(-1), 3)
    local model = GetEntityModel(GetPlayerPed(-1))
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

Citizen.CreateThread(function()
    Dealer = AddBlipForCoord(Config.AmmunationLocation["coords"]["x"], Config.AmmunationLocation["coords"]["y"], Config.AmmunationLocation["coords"]["z"])

    SetBlipSprite (Dealer, 110)
    SetBlipDisplay(Dealer, 4)
    SetBlipScale  (Dealer, 0.7)
    SetBlipAsShortRange(Dealer, true)
    SetBlipColour(Dealer, 1)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Ammunition Overval")
    EndTextCommandSetBlipName(Dealer)
end)