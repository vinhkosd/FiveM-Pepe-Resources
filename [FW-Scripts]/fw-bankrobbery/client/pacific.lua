local Count = 0
local MoneyBag = nil
local GrabbingMoney = false
local MoneyModel = GetHashKey("hei_prop_heist_cash_pile")

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearAnything = false
            for k, v in pairs(Config.SpecialBanks) do
                   if v['Open'] then
                    for Troll, Trolly in pairs(Config.Trollys) do
                        local Distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Trolly['Coords']['X'], Trolly['Coords']['Y'], Trolly['Coords']['Z'], true)
                        if Distance < 1.5 then
                            NearAnything = true
                            if not Trolly['Open-State'] then
                             DrawMarker(2, Trolly['Grab-Coords']['X'], Trolly['Grab-Coords']['Y'], Trolly['Grab-Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 242, 148, 41, 255, false, false, false, 1, false, false, false)
                             DrawText3D(Trolly['Grab-Coords']['X'], Trolly['Grab-Coords']['Y'], Trolly['Grab-Coords']['Z'],'~g~E~s~ - Geld Graaien')
                             if IsControlJustReleased(0, 38) then
                                GetMoneyFromTrolly(Troll)
                             end
                            end
                        end
                    end
                   end
                   if not v['Open'] then
                        local Area = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v['Hack-Door']['X'], v['Hack-Door']['Y'], v['Hack-Door']['Z'], true)
                        if Area < 1.3 then
                            NearAnything = true
                            DrawMarker(2, v['Hack-Door']['X'], v['Hack-Door']['Y'], v['Hack-Door']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                            if not ShowedItemsPacific then
                            ShowedItemsPacific = true
                            TriggerEvent('fw-inventory:client:requiredItems', PacificItems, true)
                            end
                        end
                   end
                end
            if not NearAnything then
                Citizen.Wait(1000)
                ShowedItemsPacific = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if GrabbingMoney then
              TriggerServerEvent('fw-bankrobbery:server:rob:pacific:money')
              Citizen.Wait(1000)
            end
        end
    end
end)

RegisterNetEvent('fw-bankrobbery:client:use:black-card')
AddEventHandler('fw-bankrobbery:client:use:black-card', function()
    for k, v in pairs(Config.SpecialBanks) do 
            if not v['Open'] then
                local Area = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v['Hack-Door']['X'], v['Hack-Door']['Y'], v['Hack-Door']['Z'], true)
                if Area < 1.35 then
                    if CurrentCops >= Config.NeededCopsPacific then
                        Framework.Functions.TriggerCallback('fw-bankrobbery:server:HasItem', function(HasItem)
                            if HasItem then
                                Framework.Functions.TriggerCallback("fw-bankrobbery:server:get:status", function(Status)
                                    if not Status then
                                        TriggerServerEvent('fw-police:server:send:big:bank:alert', GetEntityCoords(GetPlayerPed(-1)), Framework.Functions.GetStreetLabel())
                                        TriggerEvent('fw-inventory:client:set:busy', true)
                                        TriggerEvent('fw-inventory:client:requiredItems', PacificItems, false)
                                        exports['minigame-phone']:ShowHack()
                                        exports['minigame-phone']:StartHack(math.random(1,4), 130, function(Success)
                                            if Success then
                                                TriggerEvent("utk_fingerprint:Start", 4, 6, 2, function(Outcome)
                                                    if Outcome then
                                                        CreateTrollys()
                                                        TriggerServerEvent('fw-bankrobbery:server:pacific:start')
                                                        TriggerServerEvent('Framework:Server:RemoveItem', 'black-card', 1)
                                                        TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items['black-card'], "remove")
                                                        TriggerEvent('fw-inventory:client:set:busy', false)
                                                        PlayDoorSound()
                                                    end
                                                end)
                                            else
                                                Framework.Functions.Notify("Je hebt gefaalt..", "error")
                                                TriggerEvent('fw-inventory:client:set:busy', false)
                                            end
                                            exports['minigame-phone']:HideHack()
                                        end)
                                    else
                                        Framework.Functions.Notify("Er is al een overval bezig..", "error")
                                    end
                                end)
                            else
                                Framework.Functions.Notify("Je mist iets..", "error")
                            end
                        end, "electronickit")  
                    else
                        Framework.Functions.Notify("Niet genoeg agenten! ("..Config.NeededCopsPacific.." Nodig)", "info")
                    end
                end
            end
    end
end)

RegisterNetEvent('fw-bankrobbery:client:pacific:start')
AddEventHandler('fw-bankrobbery:client:pacific:start', function()
    OpenPacificDoor()
    Config.SpecialBanks[1]['Open'] = true
end)

RegisterNetEvent('fw-bankrobbery:client:clear:trollys')
AddEventHandler('fw-bankrobbery:client:clear:trollys', function()
    Count = 0
    for k, v in pairs(Config.Trollys) do
        local ObjectOne = GetClosestObjectOfType(v["Coords"]["X"], v["Coords"]["Y"], v["Coords"]["Z"], 20.0, 269934519, false, false, false)
        local ObjectTwo = GetClosestObjectOfType(v["Coords"]["X"], v["Coords"]["Y"], v["Coords"]["Z"], 20.0, 769923921, false, false, false)
        DeleteEntity(ObjectOne)
        DeleteObject(ObjectOne)
        DeleteEntity(ObjectTwo)
        DeleteObject(ObjectTwo)
    end
    for k,v in pairs(Config.Trollys) do 
        v['Open-State'] = false
    end
end)

RegisterNetEvent('fw-bankrobbery:client:set:trolly:state')
AddEventHandler('fw-bankrobbery:client:set:trolly:state', function(TrollyNumber, bool)
    Config.Trollys[TrollyNumber]['Open-State'] = bool
end)


function GetMoneyFromTrolly(TrollyNumber)
    local CurrentTrolly = GetClosestObjectOfType(Config.Trollys[TrollyNumber]['Coords']['X'], Config.Trollys[TrollyNumber]['Coords']['Y'], Config.Trollys[TrollyNumber]['Coords']['Z'], 1.0, 269934519, false, false, false)
    local MoneyObject = CreateObject(MoneyModel, GetEntityCoords(GetPlayerPed(-1)), true)
    SetEntityVisible(MoneyObject, false, false)
	AttachEntityToEntity(MoneyObject, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
	local GrabBag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(PlayerPedId()), true, false, false)
    local GrabOne = NetworkCreateSynchronisedScene(GetEntityCoords(CurrentTrolly), GetEntityRotation(CurrentTrolly), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(GetPlayerPed(-1), GrabOne, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(GrabBag, GrabOne, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    SetPedComponentVariation(GetPlayerPed(-1), 5, 0, 0, 0)
    NetworkStartSynchronisedScene(GrabOne)
    Citizen.Wait(1500)
    GrabbingMoney = true
    SetEntityVisible(MoneyObject, true, true)
    local GrabTwo = NetworkCreateSynchronisedScene(GetEntityCoords(CurrentTrolly), GetEntityRotation(CurrentTrolly), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(GetPlayerPed(-1), GrabTwo, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(GrabBag, GrabTwo, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(CurrentTrolly, GrabTwo, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(GrabTwo)
    Citizen.Wait(37000)
    SetEntityVisible(MoneyObject, false, false)
    local GrabThree = NetworkCreateSynchronisedScene(GetEntityCoords(CurrentTrolly), GetEntityRotation(CurrentTrolly), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(GetPlayerPed(-1), GrabThree, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(GrabBag, GrabThree, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(GrabThree)
    NewTrolley = CreateObject(769923921, GetEntityCoords(CurrentTrolly) + vector3(0.0, 0.0, - 0.985), true, false, false)
    SetEntityRotation(NewTrolley, GetEntityRotation(CurrentTrolly))
    GrabbingMoney = false
    TriggerServerEvent('fw-bankrobbery:server:set:trolly:state', TrollyNumber, true)
    while not NetworkHasControlOfEntity(CurrentTrolly) do
        Citizen.Wait(1)
        NetworkRequestControlOfEntity(CurrentTrolly)
    end
    DeleteObject(CurrentTrolly)
    while DoesEntityExist(CurrentTrolly) do
        Citizen.Wait(1)
        DeleteObject(CurrentTrolly)
    end
    PlaceObjectOnGroundProperly(NewTrolley)
    Citizen.Wait(1800)
    DeleteEntity(GrabBag)
    DeleteObject(MoneyObject)
end

function CreateTrollys()
    RequestModel("hei_prop_hei_cash_trolly_01")
    for k,v in pairs(Config.Trollys) do
        Trolley = CreateObject(269934519, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], 1, 0, 0)
        SetEntityHeading(Trolley, v['Coords']['H'])
	    FreezeEntityPosition(Trolley, true)
	    SetEntityInvincible(Trolley, true)
        PlaceObjectOnGroundProperly(Trolley)
    end
end

function OpenPacificDoor()
    local DoorObject = GetClosestObjectOfType(Config.SpecialBanks[1]["Bank-Door"]["X"], Config.SpecialBanks[1]["Bank-Door"]["Y"], Config.SpecialBanks[1]["Bank-Door"]["Z"], 20.0, Config.SpecialBanks[1]["Bank-Door"]["Object"], false, false, false)
    local CurrentHeading = Config.SpecialBanks[1]["Bank-Door"]['Closed'] 
    if DoorObject ~= 0 then
        Citizen.CreateThread(function()
        while true do
            if CurrentHeading ~= Config.SpecialBanks[1]["Bank-Door"]['Opend'] then
                SetEntityHeading(DoorObject, CurrentHeading - 5)
                CurrentHeading = CurrentHeading - 0.5
            else
                break
            end
            Citizen.Wait(45)
        end
     end)
    end
end

function ClosePacificDoor()
    local Object = GetClosestObjectOfType(Config.SpecialBanks[1]["Bank-Door"]["X"], Config.SpecialBanks[1]["Bank-Door"]["Y"], Config.SpecialBanks[1]["Bank-Door"]["Z"], 5.0, Config.SpecialBanks[1]["Bank-Door"]['Object'], false, false, false)
    if Object ~= 0 then
        SetEntityHeading(Object, Config.SpecialBanks[1]["Bank-Door"]['Closed'])
    end
end

function PlayDoorSound()
    repeat
      PlaySoundFrontend(-1, "OPENING", "MP_PROPERTIES_ELEVATOR_DOORS" , 1)
      Citizen.Wait(900)
      Count = Count + 1
    until Count == 16
end