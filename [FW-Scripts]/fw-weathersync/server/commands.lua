Framework.Commands.Add("blackout", "Toggle blackout", {}, false, function(source, args)
    ToggleBlackout()
end, "admin")

Framework.Commands.Add("clock", "Geef een item aan een speler", {}, false, function(source, args)
    if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
        SetExactTime(args[1], args[2])
    end
end, "admin")

Framework.Commands.Add("tijd", "Stel de tijd in", {}, false, function(source, args)
    for _, v in pairs(AvailableTimeTypes) do
        if args[1]:upper() == v then
            SetTime(args[1])
            return
        end
    end
end, "admin")

Framework.Commands.Add("weer", "Stel het weer in", {}, false, function(source, args)
    for _, v in pairs(AvailableWeatherTypes) do
        if args[1]:upper() == v then
            SetWeather(args[1])
            return
        end
    end
end, "admin")

Framework.Commands.Add("freeze", "Freeze de tijd of weer", {}, false, function(source, args)
    if args[1]:lower() == 'weer' or args[1]:lower() == 'tijd' then
        FreezeElement(args[1])
    else
        TriggerClientEvent('Framework:Notify', source, "Onjuiste invoer! Gebruik: /freeze (weer of tijd)", "error")
    end
end, "admin")