local TotalPain = 0
local TotalBroken = 0
local LastDamage, Bone = {}
local DamageDone = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            if not Config.IsDeath then
               LastDamage, Bone = GetPedLastDamageBone(PlayerPedId())
               if Bone ~= LastBone then
                  if Config.BodyParts[Bone] ~= 'NONE' then
                      ApplyDamageToBodyPart(Config.BodyParts[Bone])
                      LastBone = Bone
                  end
               else
                   Citizen.Wait(100)
               end
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            if not Config.IsDeath then
               for k, v in pairs(Config.BodyHealth) do
                   Citizen.Wait(10)
                   if v['Health'] <= 2 and not v['IsDead'] then
                       if not v['Pain'] then
                           v['Pain'] = true
                           TotalPain = TotalPain + 1
                       else
                           Citizen.Wait(150)
                       end
                   else
                       Citizen.Wait(150)         
                   end
               end
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            if not Config.IsDeath then
               for k, v in pairs(Config.BodyHealth) do
                   Citizen.Wait(25)
                   if v['Pain'] then
                      if TotalPain > 1 then
                        Framework.Functions.Notify("Bạn đang bị tổn thương ở một số bộ phận trên cơ thể..", 'info')
                      else
                        Framework.Functions.Notify("Bạn đang bị tổn thương ở "..v['Name']..'..', 'info')
                      end
                      ApplyDamageToBodyPart(k)
                      HurtPlayer(TotalPain)
                      Citizen.Wait(30000)
                    elseif not v['Pain'] and v['IsDead'] then
                        if TotalBroken > 1 then
                            Framework.Functions.Notify("Bạn bị tổn thương nặng ở 1 số bộ phận trên cơ thể..", 'error')
                        else
                            Framework.Functions.Notify("Phần "..v['Name'].. ' đã bị tổn thương nặng..', 'error')
                        end
                        if k == 'HEAD' then
                            if math.random(1, 100) <= 55 then
                                BlackOut()
                            end
    
                        elseif k == 'LLEG' or k == 'RLEG' or k == 'LFOOT' or k == 'RFOOT' then
                            if math.random(1, 100) < 50 then
                                SetPedToRagdollWithFall(PlayerPedId(), 2500, 9000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                            end
                        end
                        Citizen.Wait(30000)
                    end
                    Citizen.Wait(150)
               end
            else
                Citizen.Wait(1500)
            end
        end
    end
end)

-- // Events \\ -- 

RegisterNetEvent('fw-hospital:client:use:bandage')
AddEventHandler('fw-hospital:client:use:bandage', function()
  Citizen.SetTimeout(1000, function()
     exports['fw-assets']:AddProp('HealthPack')
     Framework.Functions.Progressbar("use_bandage", "Đang băng bó..", 4000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
     	disableMouse = false,
     	disableCombat = true,
     }, {
        animDict = "amb@world_human_clipboard@male@idle_a",
        anim = "idle_c",
        flags = 49,
     }, {}, {}, function() -- Done
         exports['fw-assets']:RemoveProp()
         HealRandomBodyPart()
         TriggerServerEvent('Framework:Server:RemoveItem', 'bandage', 1)
         TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items['bandage'], "remove")
         StopAnimTask(GetPlayerPed(-1), "anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", 1.0)
         SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) + 10)
     end, function() -- Cancel
         exports['fw-assets']:RemoveProp()
         StopAnimTask(GetPlayerPed(-1), "anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", 1.0)
         Framework.Functions.Notify("Thất bại", "error")
     end)
  end)
end)

RegisterNetEvent('fw-hospital:client:use:health-pack')
AddEventHandler('fw-hospital:client:use:health-pack', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    local RandomTime = math.random(15000, 20000)
    if Player ~= -1 and Distance < 1.5 then
      if IsTargetDead(GetPlayerServerId(Player)) then
         exports['fw-assets']:RequestAnimationDict("mini@cpr@char_a@cpr_str")
         TaskPlayAnim( PlayerPedId(), "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 8.0, 1.0, -1, 1, 0, 0, 0, 0)
         Framework.Functions.Progressbar("hospital_revive", "Đang cứu..", RandomTime, false, true, {
             disableMovement = false,
             disableCarMovement = false,
             disableMouse = false,
             disableCombat = true,
         }, {}, {}, {}, function() -- Done
             TriggerServerEvent("Framework:Server:RemoveItem", "health-pack", 1)
             TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items["health-pack"], "remove")
             TriggerServerEvent('fw-hospital:server:revive:player', GetPlayerServerId(Player))
             StopAnimTask(GetPlayerPed(-1), 'mini@cpr@char_a@cpr_str', "cpr_pumpchest", 1.0)
             Framework.Functions.Notify("Đã cứu thành công!")
         end, function() -- Cancel
             StopAnimTask(GetPlayerPed(-1), 'mini@cpr@char_a@cpr_str', "cpr_pumpchest", 1.0)
             Framework.Functions.Notify("Thất bại!", "error")
         end)
        else
            Framework.Functions.Notify("Người chơi không bị bất tỉnh..", "error")
        end
    end
end)

RegisterNetEvent('fw-hospital:client:use:painkillers')
AddEventHandler('fw-hospital:client:use:painkillers', function()
    Citizen.SetTimeout(1000, function()
        if not Config.OnOxy then
        Framework.Functions.Progressbar("use_bandage", "Đang dùng thuốc giảm đau..", 3000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "mp_suicide",
            anim = "pill",
            flags = 49,
        }, {}, {}, function() -- Done
            StopAnimTask(GetPlayerPed(-1), "mp_suicide", "pill", 1.0)
            TriggerServerEvent("Framework:Server:RemoveItem", "painkillers", 1)
            TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items["painkillers"], "remove")
            Config.OnOxy = true
            Citizen.SetTimeout(60000, function()
                Config.OnOxy = false
             end)
        end, function() -- Cancel
            StopAnimTask(GetPlayerPed(-1), "mp_suicide", "pill", 1.0)
            Framework.Functions.Notify("Thất bại", "error")
        end)
       else
         Framework.Functions.Notify("Bạn vẫn còn oxycodone trong cơ thể..", "error")
       end 
    end)
end)

-- // Functions \\ --

function ApplyDamageToBodyPart(BodyPart)
    if not Config.OnOxy then
       if BodyPart == 'LLEG' or BodyPart == 'RLEG' or BodyPart == 'LFOOT' or BodyPart == 'RFOOT' then
           if math.random(1, 100) < 50 then
             SetPedToRagdollWithFall(PlayerPedId(), 2500, 9000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
           end
       elseif BodyPart == 'HEAD' and Config.BodyHealth['HEAD']['Health'] < 2 and not Config.BodyHealth['HEAD']['IsDead'] then
           if math.random(1, 100) < 35 then
             BlackOut()
           end
       end
   
       if Config.BodyHealth[BodyPart]['Health'] > 0 and not Config.BodyHealth[BodyPart]['IsDead'] then
           Config.BodyHealth[BodyPart]['Health'] = Config.BodyHealth[BodyPart]['Health'] - 1
       elseif Config.BodyHealth[BodyPart]['Health'] == 0 then
           if not Config.BodyHealth[BodyPart]['IsDead'] and Config.BodyHealth[BodyPart]['CanDie'] then
               Config.BodyHealth[BodyPart]['Pain'] = false
               Config.BodyHealth[BodyPart]['IsDead'] = true
               TotalPain = TotalPain - 1
               TotalBroken = TotalBroken + 1
           end
       end
    end
    while IsPedRagdoll(GetPlayerPed(-1)) do
      Citizen.Wait(10)
    end
    TriggerServerEvent('fw-police:server:CreateBloodDrop', GetEntityCoords(GetPlayerPed(-1)))
end 

function HurtPlayer(Multiplier)
  local CurrentHealth = GetEntityHealth(PlayerPedId())
  local NewHealth = CurrentHealth - math.random(1,8) * Multiplier
  if not Config.OnOxy then
    SetEntityHealth(PlayerPedId(), NewHealth)
  end
end

function BlackOut()
 if not Config.OnOxy then
    SetFlash(0, 0, 100, 4000, 100)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
    if IsPedOnFoot(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedSwimming(PlayerPedId()) then
        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
        SetPedToRagdollWithFall(PlayerPedId(), 7500, 9000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    end
    Citizen.Wait(1500)
    DoScreenFadeIn(1000)
    Citizen.Wait(1000)
    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
    Citizen.Wait(500)
    DoScreenFadeIn(700)
 end
end

function HealRandomBodyPart()
  for k,v in pairs(Config.BodyHealth) do
      if not v['IsDead'] then
        if v['Pain'] then
            if v['Health'] < 4 then
                v['Health'] = v['Health'] + 1.0 
            end

            if v['Health'] == 4 then
                v['Pain'] = false
                TotalPain = TotalPain - 1
            end

        end
      end
  end
end

function ResetBodyHp()
    for k,v in pairs(Config.BodyHealth) do
        v['Health'] = Config.MaxBodyPartHealth
        v['IsDead'] = false
        v['Pain'] = false
        TotalPain = 0
        TotalBroken = 0
    end
end