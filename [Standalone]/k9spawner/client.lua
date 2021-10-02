---Coded by Jeremiah:0420
RegisterCommand("k9", function(source,args,rawCommand)
    spawnped("a_c_shepherd")
    DisplayNotification("Je bent nu een K-9")
end, false)


---Spawn Model Code
function spawnped(pedhash)
    local ped = PlayerId()
    local model = GetHashKey(pedhash)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
    SetPlayerModel(ped, model)
    SetModelAsNoLongerNeeded(model)
end

---Give Weapon Code
function giveWeapon(gunhash)
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(gunhash), 999, false)
    SetPedArmour(GetPlayerPed(-1), 100)
end

function DisplayNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end