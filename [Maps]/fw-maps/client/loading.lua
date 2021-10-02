Citizen.CreateThread(function()
    -- Prison
    RequestIpl("bobo_prison_milo_")
    LoadInterior(GetInteriorAtCoords(1784.804, 2590.823, 45.71721))
    ActivateInteriorEntitySet(GetInteriorAtCoords(1784.804, 2590.823, 45.71721), "shell")
    ActivateInteriorEntitySet(GetInteriorAtCoords(1784.804, 2590.823, 45.71721), "bobo_prison_shell")
    RefreshInterior(GetInteriorAtCoords(1784.804, 2590.823, 45.71721))
    Citizen.Wait(50)
    -- Lobby
    RequestIpl("bobo_prison_lobby_milo_")
    ActivateInteriorEntitySet(GetInteriorAtCoords(1833.621, 2585.082, 45.89189), "shell")
    ActivateInteriorEntitySet(GetInteriorAtCoords(1833.621, 2585.082, 45.89189), "bobo_prison_lobby_shell")
    RefreshInterior(GetInteriorAtCoords(1833.621, 2585.082, 45.89189))
end)