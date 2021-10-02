Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if LoggedIn then
            InRange = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local PaletoDoorDistance = GetDistanceBetweenCoords(PlayerCoords, Config.BankLocations[6]["Coords"]["X"], Config.BankLocations[6]["Coords"]["Y"], Config.BankLocations[6]["Coords"]["Z"])
            if PaletoDoorDistance < 30 then
                if not Config.BankLocations[6]['IsOpened'] then
                    InRange = true
                    CloseBankDoor(6)
                end
            end
            if not InRange then
                Citizen.Wait(1500)
            end
            Citizen.Wait(3000)
        end
    end
end)