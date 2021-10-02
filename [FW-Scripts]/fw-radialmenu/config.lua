local DutyVehicles = {}
HasHandCuffs = false

Config = Config or {}

Config.Keys = {["F1"] = 288}

Config.Menu = {
 [1] = {
    id = "citizen",
    displayName = "Cơ bản",
    icon = "#citizen-action",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() then
            return true
        end
    end,
    subMenus = {"citizen:escort", 'citizen:steal', 'citizen:contact', 'citizen:vehicle:getout', 'citizen:vehicle:getin', 'citizen:corner:selling'}
 },
 [2] = {
    id = "animations",
    displayName = "Dáng đi",
    icon = "#walking",
    enableMenu = function()
       if not exports['fw-hospital']:GetDeathStatus() then
           return true
        end
    end,
    subMenus = { "animations:brave", "animations:hurry", "animations:business", "animations:tipsy", "animations:injured","animations:tough", "animations:default", "animations:hobo", "animations:money", "animations:swagger", "animations:shady", "animations:maneater", "animations:chichi", "animations:sassy", "animations:sad", "animations:posh", "animations:alien" }
 },
 [3] = {
     id = "expressions",
     displayName = "Biểu cảm",
     icon = "#expressions",
     enableMenu = function()
         if not exports['fw-hospital']:GetDeathStatus() then
            return true
         end
     end,
     subMenus = { "expressions:normal", "expressions:drunk", "expressions:angry", "expressions:dumb", "expressions:electrocuted", "expressions:grumpy", "expressions:happy", "expressions:injured", "expressions:joyful", "expressions:mouthbreather", "expressions:oneeye", "expressions:shocked", "expressions:sleeping", "expressions:smug", "expressions:speculative", "expressions:stressed", "expressions:sulking", "expressions:weird", "expressions:weird2"}
 },
 [4] = {
    id = "police",
    displayName = "Cảnh sát",
    icon = "#police-action",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'police' and Framework.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"police:panic", "police:search", "police:tablet", "police:impound", "police:resetdoor", "police:enkelband", "police:dispatch"}
 },
 [5] = {
    id = "police",
    displayName = "Radio Channels",
    icon = "#police-radio-channel",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'police' and Framework.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"police:radio:one", "police:radio:two", "police:radio:three", "police:radio:four", "police:radio:five"}
 },
 [6] = {
    id = "police",
    displayName = "Đồ cảnh sát",
    icon = "#police-action",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'police' and Framework.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"police:object:cone", "police:object:barrier", "police:object:tent", "police:object:light", "police:object:schot", "police:object:delete"}
 },
 [7] = {
    id = "police-down",
    displayName = "10-13A",
    icon = "#police-down",
    close = true,
    functiontype = "client",
    functionParameters = 'Urgent',
    functionName = "fw-radialmenu:client:send:down",
    enableMenu = function()
        if exports['fw-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'police' and Framework.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
 },
 [8] = {
    id = "police-down",
    displayName = "10-13B",
    icon = "#police-down",
    close = true,
    functiontype = "client",
    functionParameters = 'Normal',
    functionName = "fw-radialmenu:client:send:down",
    enableMenu = function()
        if exports['fw-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'police' and Framework.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
 },
 [9] = {
    id = "ambulance",
    displayName = "Cấp cứu",
    icon = "#ambulance-action",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'ambulance' and Framework.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"ambulance:heal", "ambulance:revive", "police:panic", "ambulance:blood"}
 },
 [10] = {
    id = "vehicle",
    displayName = "Xe",
    icon = "#citizen-action-vehicle",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() then
            local Vehicle, Distance = Framework.Functions.GetClosestVehicle()
            if Vehicle ~= 0 and Distance < 2.3 then
                return true
            end
        end
    end,
    subMenus = {"vehicle:flip", "vehicle:key"}
 },
 [11] = {
    id = "vehicle-doors",
    displayName = "Menu xe",
    icon = "#citizen-action-vehicle",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() then
            if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) and not IsPedInAnyBoat(GetPlayerPed(-1)) and not IsPedInAnyHeli(GetPlayerPed(-1)) and not IsPedOnAnyBike(GetPlayerPed(-1)) then
                return true
            end
        end
    end,
    subMenus = {"vehicle:door:motor", "vehicle:door:left:front", "vehicle:door:right:front", "vehicle:door:trunk", "vehicle:door:right:back", "vehicle:door:left:back"}
 },
 [12] = {
    id = "police-garage",
    displayName = "Ga-ra cảnh sát",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() then
            if exports['fw-police']:GetGarageStatus() then
                return true
            end
        end
    end,
    subMenus = {}
 },
 [13] = {
    id = "garage",
    displayName = "Ga-ra",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() then
            if exports['fw-garages']:IsNearGarage() then
                return true
            end
        end
    end,
    subMenus = {"garage:putin", "garage:getout"}
 },
 [14] = {
    id = "atm",
    displayName = "Bank",
    icon = "#global-bank",
    close = true,
    functiontype = "client",
    functionName = "fw-banking:client:open:bank",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() then
            if exports['fw-banking']:IsNearAnyBank() then
                return true
            end
        end
  end,
 },
 [15] = {
    id = "appartment",
    displayName = "Đi vào trong",
    icon = "#global-appartment",
    close = true,
    functiontype = "client",
    functionParameters = false,
    functionName = "fw-appartments:client:enter:appartment",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() then
            if exports['fw-appartments']:IsNearHouse() then
                return true
            end
        end
  end,
 },
 [16] = {
    id = "depot",
    displayName = "Depot",
    icon = "#global-depot",
    close = true,
    functiontype = "client",
    functionParameters = false,
    functionName = "fw-garages:client:open:depot",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() then
            if exports['fw-garages']:IsNearDepot() then
                return true
            end
        end
  end,
 },
 [17] = {
    id = "housing",
    displayName = "Naar Binnen",
    icon = "#global-appartment",
    close = true,
    functiontype = "client",
    functionParameters = false,
    functionName = "fw-housing:client:enter:house",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() then
            if exports['fw-housing']:EnterNearHouse() then
                return true
            end
        end
  end,
 },
 [18] = {
    id = "housing-options",
    displayName = "Huis Opties",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() then
            if exports['fw-housing']:HasEnterdHouse() then
                return true
            end
        end
    end,
    subMenus = {"house:setstash", "house:setlogout", "house:setclothes", "house:givekey", "house:decorate" }
 },
 [19] = {
    id = "judge-actions",
    displayName = "Rechter",
    icon = "#judge-actions",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'judge' then
            return true
        end
    end,
    subMenus = {"judge:tablet", "judge:job", "police:tablet"}
 },
 [20] = {
    id = "ambulance-garage",
    displayName = "Ambulance Garage",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'ambulance' and Framework.Functions.GetPlayerData().job.onduty then
            if exports['fw-hospital']:NearGarage() then
                return true
            end
        end
    end,
    subMenus = {"ambulance:garage:sprinter", "ambulance:garage:touran", "ambulance:garage:heli", "vehicle:delete"}
 },
 [21] = {
    id = "scrapyard",
    displayName = "Xóa xe",
    icon = "#police-action-vehicle-spawn",
    close = true,
    functiontype = "client",
    functionName = "fw-materials:client:scrap:vehicle",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() then
          if exports['fw-materials']:IsNearScrapYard() then
            return true
          end
        end
  end,
  },
  [22] = {
    id = "cityhall",
    displayName = "Gemeente Huis",
    icon = "#global-cityhall",
    close = true,
    functiontype = "client",
    functionName = "fw-cityhall:client:open:nui",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() then
            if exports['fw-cityhall']:CanOpenCityHall() then
                return true
            end
        end
  end,
 },
 [23] = {
    id = "dealer",
    displayName = "Dealer Shop",
    icon = "#global-dealer",
    close = true,
    functiontype = "client",
    functionName = "fw-dealers:client:open:dealer",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() then
            if exports['fw-dealers']:CanOpenDealerShop() then
                return true
            end
        end
  end,
 },
 [24] = {
    id = "traphouse",
    displayName = "Traphouse",
    icon = "#global-appartment",
    close = true,
    functiontype = "client",
    functionName = "fw-traphouse:client:enter",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() then
            if exports['fw-traphouse']:CanPlayerEnterTraphouse() then
                return true
            end
        end
  end,
 },
 [25] = {
    id = "tow-menu",
    displayName = "Bergnet Acties",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'tow' then
            return true
        end
    end,
    subMenus = {"tow:hook", "tow:npc"}
 },
 [26] = {
    id = "cuff",
    displayName = "Boeien",
    icon = "#citizen-action-cuff",
    close = true,
    functiontype = "client",
    functionName = "fw-police:client:cuff:closest",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() and HasHandCuffs then
          return true
        end
  end,
 },
 [27] = {
    id = "trunk",
    displayName = "Uit Kofferbak",
    icon = "#citizen-vehicle-trunk",
    close = true,
    functiontype = "client",
    functionName = "fw-eye:client:getout:trunk",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() and exports['fw-eye']:GetInTrunkState() then
          return true
        end
  end,
 },
 [28] = {
    id = "cardealer-menu",
    displayName = "Auto Verkoper",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'cardealer' then
            return true
        end
    end,
    subMenus = {"cardealer:tablet"}
 },
 [29] = {
    id = "cardealer-menu",
    displayName = "Auto Verkoper",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['fw-hospital']:GetDeathStatus() and Framework.Functions.GetPlayerData().job.name == 'cardealer2' then
            return true
        end
    end,
    subMenus = {"cardealer2:tablet"}
 },
 [30] = {
    id = "cornerselling-menu",
    displayName = "Bán hàng",
    icon = "#citizen-corner",
    functiontype = "client",
    functionName = "fw-illegal:client:sell:to:ped",
    enableMenu = function()
        if exports['fw-illegal']:isNearByNPC() then
            return true
        end
    end,
 },
}

Config.SubMenus = {
    ['police:radio:one'] = {
     title = "Radio #1",
     icon = "#police-radio",
     close = true,
     functionParameters = 1,
     functiontype = "client",
     functionName = "fw-radialmenu:client:enter:radio"
    },
    ['police:radio:two'] = {
     title = "Radio #2",
     icon = "#police-radio",
     close = true,
     functionParameters = 2,
     functiontype = "client",
     functionName = "fw-radialmenu:client:enter:radio"
    },
    ['police:radio:three'] = {
     title = "Radio #3",
     icon = "#police-radio",
     close = true,
     functionParameters = 3,
     functiontype = "client",
     functionName = "fw-radialmenu:client:enter:radio"
    },
    ['police:radio:four'] = {
     title = "Radio #4",
     icon = "#police-radio",
     close = true,
     functionParameters = 4,
     functiontype = "client",
     functionName = "fw-radialmenu:client:enter:radio"
    },
    ['police:radio:five'] = {
     title = "Radio #5",
     icon = "#police-radio",
     close = true,
     functionParameters = 5,
     functiontype = "client",
     functionName = "fw-radialmenu:client:enter:radio"
    },
    ['police:panic'] = {
     title = "Khẩn cấp",
     icon = "#police-action-panic",
     close = true,
     functiontype = "client",
     functionName = "fw-radialmenu:client:send:panic:button"
    },
    ['police:dispatch'] = {
     title = "Thông báo gần đây",
     icon = "#police-action-bell",
     close = true,
     functiontype = "server",
     functionName = "fw-radialmenu:server:open:dispatch"
    },
    ['police:tablet'] = {
     title = "MEOS Tablet",
     icon = "#police-action-tablet",
     close = true,
     functiontype = "client",
     functionName = "fw-police:client:show:tablet"
    },
    ['police:impound'] = {
     title = "Giam xe",
     icon = "#police-action-vehicle",
     close = true,
     functiontype = "client",
     functionName = "fw-police:client:impound:closest"
    },
    ['police:search'] = {
     title = "Tìm kiếm",
     icon = "#police-action-search",
     close = true,
     functiontype = "client",
     functionName = "fw-police:client:search:closest"
    },
    ['police:resetdoor'] = {
     title = "Reset Huis Deur",
     icon = "#global-appartment",
     close = true,
     functiontype = "client",
     functionName = "fw-housing:client:reset:house:door"
    },
    ['police:enkelband'] = {
     title = "Enkelband",
     icon = "#police-action-enkelband",
     close = true,
     functiontype = "client",
     functionName = "fw-police:client:enkelband:closest"
    },
    ['police:vehicle:touran'] = {
     title = "Politie Touran",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieTouran',
     functiontype = "client",
     functionName = "fw-police:client:spawn:vehicle"
    },
    ['police:vehicle:klasse'] = {
     title = "Politie B-Klasse",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieKlasse',
     functiontype = "client",
     functionName = "fw-police:client:spawn:vehicle"
    },
    ['police:vehicle:vito'] = {
     title = "Politie Vito",
     icon = "#police-action-vehicle-spawn-bus",
     close = true,
     functionParameters = 'PolitieVito',
     functiontype = "client",
     functionName = "fw-police:client:spawn:vehicle"
    },
    ['police:vehicle:audi'] = {
     title = "Politie Audi",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieRS6',
     functiontype = "client",
     functionName = "fw-police:client:spawn:vehicle"
    },
    ['police:vehicle:velar'] = {
     title = "Politie Unmarked Velar",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieVelar',
     functiontype = "client",
     functionName = "fw-police:client:spawn:vehicle"
    },
    ['police:vehicle:bmw'] = {
     title = "Politie Unmarked M5",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieBmw',
     functiontype = "client",
     functionName = "fw-police:client:spawn:vehicle"
    },
    ['police:vehicle:unmaked:audi'] = {
     title = "Politie Unmarked A6",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'PolitieAudiUnmarked',
     functiontype = "client",
     functionName = "fw-police:client:spawn:vehicle"
    },
    ['police:vehicle:heli'] = {
     title = "Trực thăng cảnh sát",
     icon = "#police-action-vehicle-spawn-heli",
     close = true,
     functionParameters = 'PolitieZulu',
     functiontype = "client",
     functionName = "fw-police:client:spawn:vehicle"
    },
    ['police:vehicle:motor'] = {
     title = "Moto cảnh sát",
     icon = "#police-action-vehicle-spawn-motor",
     close = true,
     functionParameters = 'PolitieMotor',
     functiontype = "client",
     functionName = "fw-police:client:spawn:vehicle"
    },
    ['police:object:cone'] = {
     title = "Nón lưu thượng",
     icon = "#global-box",
     close = true,
     functionParameters = 'cone',
     functiontype = "client",
     functionName = "fw-police:client:spawn:object"
    },
    ['police:object:barrier'] = {
     title = "Rào chắn",
     icon = "#global-box",
     close = true,
     functionParameters = 'barrier',
     functiontype = "client",
     functionName = "fw-police:client:spawn:object"
    },
    ['police:object:schot'] = {
     title = "Chắn đạn",
     icon = "#global-box",
     close = true,
     functionParameters = 'schot',
     functiontype = "client",
     functionName = "fw-police:client:spawn:object"
    },
    ['police:object:tent'] = {
     title = "Lều",
     icon = "#global-tent",
     close = true,
     functionParameters = 'tent',
     functiontype = "client",
     functionName = "fw-police:client:spawn:object"
    },
    ['police:object:light'] = {
     title = "Trụ ddèn",
     icon = "#global-box",
     close = true,
     functionParameters = 'light',
     functiontype = "client",
     functionName = "fw-police:client:spawn:object"
    },
    ['police:object:delete'] = {
     title = "Xóa vật thể",
     icon = "#global-delete",
     close = false,
     functiontype = "client",
     functionName = "fw-police:client:delete:object"
    },
    ['ambulance:heal'] = {
      title = "Hồi máu người chơi",
      icon = "#ambulance-action-heal",
      close = true,
      functiontype = "client",
      functionName = "fw-hospital:client:heal:closest"
    },
    ['ambulance:revive'] = {
      title = "Hồi sinh người chơi",
      icon = "#ambulance-action-heal",
      close = true,
      functiontype = "client",
      functionName = "fw-hospital:client:revive:closest"
    },
    ['ambulance:blood'] = {
      title = "Lấy máu",
      icon = "#ambulance-action-blood",
      close = true,
      functiontype = "client",
      functionName = "fw-hospital:client:take:blood:closest"
    },
    ['ambulance:garage:heli'] = {
      title = "Máy bay cứu thương",
      icon = "#police-action-vehicle-spawn",
      close = true,
      functionParameters = 'AmbulanceHeli',
      functiontype = "client",
      functionName = "fw-hospital:client:spawn:vehicle"
    },
    ['ambulance:garage:touran'] = {
     title = "Xe cứu thương Touran",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'AmbulanceTouran',
     functiontype = "client",
     functionName = "fw-hospital:client:spawn:vehicle"
    },
    ['ambulance:garage:sprinter'] = {
     title = "Xe cứu thương Sprinter",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'AmbulanceSprinter',
     functiontype = "client",
     functionName = "fw-hospital:client:spawn:vehicle"
    },
    ['vehicle:delete'] = {
     title = "Xóa xe",
     icon = "#police-action-vehicle-delete",
     close = true,
     functiontype = "client",
     functionName = "Framework:Command:DeleteVehicle"
    },
    ['cardealer:tablet'] = {
     title = "Tablet",
     icon = "#police-action-tablet",
     close = true,
     functiontype = "client",
     functionName = "fw-cardealer:client:open:tablet"
    },
    ['cardealer2:tablet'] = {
     title = "Tablet",
     icon = "#police-action-tablet",
     close = true,
     functiontype = "client",
     functionName = "fw-cardealer2:client:open:tablet"
    },
    ['judge:tablet'] = {
     title = "Rechter Tablet",
     icon = "#police-action-tablet",
     close = true,
     functiontype = "client",
     functionName = "fw-judge:client:toggle"
    },
    ['judge:job'] = {
     title = "Thuê luật sư",
     icon = "#judge-actions",
     close = true,
     functiontype = "client",
     functionName = "fw-judge:client:lawyer:add:closest"
    },
    ['citizen:corner:selling'] = {
     title = "Corner Selling",
     icon = "#citizen-corner",
     close = true,
     functiontype = "client",
     functionName = "fw-illegal:client:toggle:corner:selling"
    },
    ['citizen:contact'] = {
     title = "Đưa thông tin liên hệ",
     icon = "#citizen-contact",
     close = true,
     functiontype = "client",
     functionName = "fw-phone:client:GiveContactDetails"
    },
    ['citizen:escort'] = {
     title = "Hộ tống",
     icon = "#citizen-action-escort",
     close = true,
     functiontype = "client",
     functionName = "fw-police:client:escort:closest"
    },
    ['citizen:steal'] = {
     title = "Cướp",
     icon = "#citizen-action-steal",
     close = true,
     functiontype = "client",
     functionName = "fw-police:client:steal:closest"
    },
    ['citizen:vehicle:getout'] = {
     title = "Lôi ra khỏi xe",
     icon = "#citizen-put-out-veh",
     close = true,
     functiontype = "client",
     functionName = "fw-police:client:SetPlayerOutVehicle"
    },
    ['citizen:vehicle:getin'] = {
     title = "Đặt vào xe",
     icon = "#citizen-put-in-veh",
     close = true,
     functiontype = "client",
     functionName = "fw-police:client:PutPlayerInVehicle"
    },
    ['vehicle:flip'] = {
     title = "Lật xe",
     icon = "#citizen-action-vehicle",
     close = true,
     functiontype = "client",
     functionName = "fw-radialmenu:client:flip:vehicle"
    },
    ['vehicle:key'] = {
     title = "Đưa chìa khóa",
     icon = "#citizen-action-vehicle-key",
     close = true,
     functiontype = "client",
     functionName = "fw-vehiclekeys:client:give:key"
    },

    ['vehicle:door:left:front'] = {
     title = "Cửa trái trước",
     icon = "#global-arrow-left",
     close = true,
     functionParameters = 0,
     functiontype = "client",
     functionName = "fw-radialmenu:client:open:door"
    },
    ['vehicle:door:motor'] = {
     title = "Mở mui xe",
     icon = "#global-arrow-up",
     close = true,
     functionParameters = 4,
     functiontype = "client",
     functionName = "fw-radialmenu:client:open:door"
    },
    ['vehicle:door:right:front'] = {
     title = "Cửa phải trước",
     icon = "#global-arrow-right",
     close = true,
     functionParameters = 1,
     functiontype = "client",
     functionName = "fw-radialmenu:client:open:door"
    },
    ['vehicle:door:right:back'] = {
     title = "Cửa phải sau",
     icon = "#global-arrow-right",
     close = true,
     functionParameters = 3,
     functiontype = "client",
     functionName = "fw-radialmenu:client:open:door"
    },
    ['vehicle:door:trunk'] = {
     title = "Mở cốp",
     icon = "#global-arrow-down",
     close = true,
     functionParameters = 5,
     functiontype = "client",
     functionName = "fw-radialmenu:client:open:door"
    },
    ['vehicle:door:left:back'] = {
     title = "Cửa trái sau",
     icon = "#global-arrow-left",
     close = true,
     functionParameters = 2,
     functiontype = "client",
     functionName = "fw-radialmenu:client:open:door"
    },


    ['tow:hook'] = {
     title = "Takel Voertuig",
     icon = "#citizen-action-vehicle",
     close = true,
     functiontype = "client",
     functionName = "fw-tow:client:hook:car"
    },
    ['tow:npc'] = {
     title = "Toggle NPC",
     icon = "#citizen-action",
     close = true,
     functiontype = "client",
     functionName = "fw-tow:client:toggle:npc"
    },



    ['garage:putin'] = {
     title = "In Garage",
     icon = "#citizen-put-in-veh",
     close = true,
     functiontype = "client",
     functionName = "fw-garages:client:check:owner"
    },
    ['garage:getout'] = {
     title = "Uit Garage",
     icon = "#citizen-put-out-veh",
     close = true,
     functiontype = "client",
     functionName = "fw-garages:client:set:vehicle:out:garage"
    }, 
    ['house:setstash'] = {
     title = "Zet Stash",
     icon = "#citizen-put-out-veh",
     close = true,
     functionParameters = 'stash',
     functiontype = "client",
     functionName = "fw-housing:client:set:location"
    },
    ['house:setlogout'] = {
     title = "Zet Loguit",
     icon = "#citizen-put-out-veh",
     close = true,
     functionParameters = 'logout',
     functiontype = "client",
     functionName = "fw-housing:client:set:location"
    },
    ['house:setclothes'] = {
     title = "Zet Kledingkast",
     icon = "#citizen-put-out-veh",
     close = true,
     functionParameters = 'clothes',
     functiontype = "client",
     functionName = "fw-housing:client:set:location"
    },
    ['house:givekey'] = {
     title = "Geef Sleutels",
     icon = "#citizen-action-vehicle-key",
     close = true,
     functiontype = "client",
     functionName = "fw-housing:client:give:keys"
    },
    ['house:decorate'] = {
     title = "Decoreren",
     icon = "#global-box",
     close = true,
     functiontype = "client",
     functionName = "fw-housing:client:decorate"
    },
    -- // Anims and Expression \\ --
    ['animations:brave'] = {
        title = "Brave",
        icon = "#animation-brave",
        close = true,
        functionName = "AnimSet:Brave",
        functiontype = "client",
    },
    ['animations:hurry'] = {
        title = "Hurry",
        icon = "#animation-hurry",
        close = true,
        functionName = "AnimSet:Hurry",
        functiontype = "client",
    },
    ['animations:business'] = {
        title = "Business",
        icon = "#animation-business",
        close = true,
        functionName = "AnimSet:Business",
        functiontype = "client",
    },
    ['animations:tipsy'] = {
        title = "Tipsy",
        icon = "#animation-tipsy",
        close = true,
        functionName = "AnimSet:Tipsy",
        functiontype = "client",
    },
    ['animations:injured'] = {
        title = "Injured",
        icon = "#animation-injured",
        close = true,
        functionName = "AnimSet:Injured",
        functiontype = "client",
    },
    ['animations:tough'] = {
        title = "Tough",
        icon = "#animation-tough",
        close = true,
        functionName = "AnimSet:ToughGuy",
        functiontype = "client",
    },
    ['animations:sassy'] = {
        title = "Sassy",
        icon = "#animation-sassy",
        close = true,
        functionName = "AnimSet:Sassy",
        functiontype = "client",
    },
    ['animations:sad'] = {
        title = "Sad",
        icon = "#animation-sad",
        close = true,
        functionName = "AnimSet:Sad",
        functiontype = "client",
    },
    ['animations:posh'] = {
        title = "Posh",
        icon = "#animation-posh",
        close = true,
        functionName = "AnimSet:Posh",
        functiontype = "client",
    },
    ['animations:alien'] = {
        title = "Alien",
        icon = "#animation-alien",
        close = true,
        functionName = "AnimSet:Alien",
        functiontype = "client",
    },
    ['animations:nonchalant'] =
    {
        title = "Nonchalant",
        icon = "#animation-nonchalant",
        close = true,
        functionName = "AnimSet:NonChalant",
        functiontype = "client",
    },
    ['animations:hobo'] = {
        title = "Hobo",
        icon = "#animation-hobo",
        close = true,
        functionName = "AnimSet:Hobo",
        functiontype = "client",
    },
    ['animations:money'] = {
        title = "Money",
        icon = "#animation-money",
        close = true,
        functionName = "AnimSet:Money",
        functiontype = "client",
    },
    ['animations:swagger'] = {
        title = "Swagger",
        icon = "#animation-swagger",
        close = true,
        functionName = "AnimSet:Swagger",
        functiontype = "client",
    },
    ['animations:shady'] = {
        title = "Shady",
        icon = "#animation-shady",
        close = true,
        functionName = "AnimSet:Shady",
        functiontype = "client",
    },
    ['animations:maneater'] = {
        title = "Man Eater",
        icon = "#animation-maneater",
        close = true,
        functionName = "AnimSet:ManEater",
        functiontype = "client",
    },
    ['animations:chichi'] = {
        title = "ChiChi",
        icon = "#animation-chichi",
        close = true,
        functionName = "AnimSet:ChiChi",
        functiontype = "client",
    },
    ['animations:default'] = {
        title = "Default",
        icon = "#animation-default",
        close = true,
        functionName = "AnimSet:default",
        functiontype = "client",
    },
    ["expressions:angry"] = {
        title="Angry",
        icon="#expressions-angry",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_angry_1" },
        functiontype = "client",
    },
    ["expressions:drunk"] = {
        title="Drunk",
        icon="#expressions-drunk",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_drunk_1" },
        functiontype = "client",
    },
    ["expressions:dumb"] = {
        title="Dumb",
        icon="#expressions-dumb",
        close = true,
        functionName = "expressions",
        functionParameters =  { "pose_injured_1" },
        functiontype = "client",
    },
    ["expressions:electrocuted"] = {
        title="Electrocuted",
        icon="#expressions-electrocuted",
        close = true,
        functionName = "expressions",
        functionParameters =  { "electrocuted_1" },
        functiontype = "client",
    },
    ["expressions:grumpy"] = {
        title="Grumpy",
        icon="#expressions-grumpy",
        close = true,
        functionName = "expressions", 
        functionParameters =  { "mood_drivefast_1" },
        functiontype = "client",
    },
    ["expressions:happy"] = {
        title="Happy",
        icon="#expressions-happy",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_happy_1" },
        functiontype = "client",
    },
    ["expressions:injured"] = {
        title="Injured",
        icon="#expressions-injured",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_injured_1" },
        functiontype = "client",
    },
    ["expressions:joyful"] = {
        title="Joyful",
        icon="#expressions-joyful",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_dancing_low_1" },
        functiontype = "client",
    },
    ["expressions:mouthbreather"] = {
        title="Mouthbreather",
        icon="#expressions-mouthbreather",
        close = true,
        functionName = "expressions",
        functionParameters = { "smoking_hold_1" },
        functiontype = "client",
    },
    ["expressions:normal"]  = {
        title="Normal",
        icon="#expressions-normal",
        close = true,
        functionName = "expressions:clear",
        functiontype = "client",
    },
    ["expressions:oneeye"]  = {
        title="One Eye",
        icon="#expressions-oneeye",
        close = true,
        functionName = "expressions",
        functionParameters = { "pose_aiming_1" },
        functiontype = "client",
    },
    ["expressions:shocked"]  = {
        title="Shocked",
        icon="#expressions-shocked",
        close = true,
        functionName = "expressions",
        functionParameters = { "shocked_1" },
        functiontype = "client",
    },
    ["expressions:sleeping"]  = {
        title="Sleeping",
        icon="#expressions-sleeping",
        close = true,
        functionName = "expressions",
        functionParameters = { "dead_1" },
        functiontype = "client",
    },
    ["expressions:smug"]  = {
        title="Smug",
        icon="#expressions-smug",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_smug_1" },
        functiontype = "client",
    },
    ["expressions:speculative"]  = {
        title="Speculative",
        icon="#expressions-speculative",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_aiming_1" },
        functiontype = "client",
    },
    ["expressions:stressed"]  = {
        title="Stressed",
        icon="#expressions-stressed",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_stressed_1" },
        functiontype = "client",
    },
    ["expressions:sulking"]  = {
        title="Sulking",
        icon="#expressions-sulking",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_sulk_1" },
        functiontype = "client",
    },
    ["expressions:weird"]  = {
        title="Weird",
        icon="#expressions-weird",
        close = true,
        functionName = "expressions",
        functionParameters = { "effort_2" },
        functiontype = "client",
    },
    ["expressions:weird2"]  = {
        title="Weird 2",
        icon="#expressions-weird2",
        close = true,
        functionName = "expressions",
        functionParameters = { "effort_3" },
        functiontype = "client",
    }
}

RegisterNetEvent('fw-radialmenu:client:update:duty:vehicles')
AddEventHandler('fw-radialmenu:client:update:duty:vehicles', function()
    Config.Menu[12].subMenus = exports['fw-police']:GetVehicleList()
end)