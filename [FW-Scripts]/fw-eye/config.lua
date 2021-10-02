Config = Config or {}

Config.TrunkData = {}

Config.ObjectOptions = {
    [GetHashKey('prop_atm_01')] = {
        [1] = {
            ['Name'] = 'Pin Automaat',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="far fa-credit-card"></i>',
            ['EventName'] = 'fw-banking:client:open:atm',
        },
    },
    [GetHashKey('prop_atm_02')] = {
        [1] = {
            ['Name'] = 'Pin Automaat',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="far fa-credit-card"></i>',
            ['EventName'] = 'fw-banking:client:open:atm',
        },
    },
    [GetHashKey('prop_atm_03')] = {
        [1] = {
            ['Name'] = 'Pin Automaat',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="far fa-credit-card"></i>',
            ['EventName'] = 'fw-banking:client:open:atm',
        },
    },
    [GetHashKey('prop_fleeca_atm')] = {
        [1] = {
            ['Name'] = 'Pin Automaat',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="far fa-credit-card"></i>',
            ['EventName'] = 'fw-banking:client:open:atm',
        },
    },
    [GetHashKey('v_ind_cs_bucket')] = {
        ['Job'] = 'police',
        [1] = {
            ['Name'] = 'In / Uit Dienst',
            ['EventType'] = 'Server',
            ['Logo'] = '<i class="fas fa-user-clock"></i>',
            ['EventName'] = 'Framework:ToggleDuty',
        },
    },
    [GetHashKey('p_amb_clipboard_01')] = {
        ['Job'] = 'ambulance',
        [1] = {
            ['Name'] = 'In / Uit Dienst',
            ['EventType'] = 'Server',
            ['Logo'] = '<i class="fas fa-bell"></i>',
            ['EventName'] = 'Framework:ToggleDuty',
        },
    },
    [GetHashKey('prop_till_01')] = {
        [1] = {
            ['Name'] = 'Winkel',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-shopping-basket"></i>',
            ['EventName'] = 'fw-stores:server:open:shop',
        },
    },
    [GetHashKey('prop_till_02')] = {
        [1] = {
            ['Name'] = 'Winkel',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-shopping-basket"></i>',
            ['EventName'] = 'fw-stores:server:open:shop',
        },
    },
    [1746653202] = {
        [1] = {
            ['Name'] = 'Praten',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-comments"></i>',
            ['EventName'] = 'fw-illegal:client:talk:to:npc',
        },
    },
    [2023152276] = {
        [1] = {
            ['Name'] = 'Praten',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-comments"></i>',
            ['EventName'] = 'fw-illegal:client:talk:to:npc',
        },
    },
    [-306958529] = {
        [1] = {
            ['Name'] = 'Praten',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-comments"></i>',
            ['EventName'] = 'fw-illegal:client:talk:to:npc',
        },
    },
    [GetHashKey('cs_old_man1a')] = {
        [1] = {
            ['Name'] = 'Slotenmaker',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-key"></i>',
            ['EventName'] = 'fw-illegal:client:talk:to:npc',
        },
    },
    [GetHashKey('s_m_m_gardener_01')] = {
        [1] = {
            ['Name'] = 'Tool Winkel',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-tools"></i>',
            ['EventName'] = 'fw-illegal:client:talk:to:npc',
        },
    },
    [GetHashKey('a_f_m_prolhost_01')] = {
        [1] = {
            ['Name'] = 'Vis Winkel',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-fish"></i>',
            ['EventName'] = 'fw-illegal:client:talk:to:npc',
        },
    },
    [GetHashKey('cs_beverly')] = {
        [1] = {
            ['Name'] = 'Praten',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-comments"></i>',
            ['EventName'] = 'fw-illegal:client:talk:to:npc',
        },
    },
    -- Koffie
    [GetHashKey('prop_vend_coffe_01')] = {
        [1] = {
            ['Name'] = 'Koffie Machine',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-coffee"></i>',
            ['EventName'] = 'fw-stores:client:open:custom:store',
            ['EventParameter'] = 'Coffee',
        },
    },
    -- Vending
    [GetHashKey('prop_vend_snak_01')] = {
        [1] = {
            ['Name'] = 'Snoep Automaat',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-candy-cane"></i>',
            ['EventName'] = 'fw-stores:client:open:custom:store',
            ['EventParameter'] = 'Vending',
        },
    },
    -- Winkel
    [GetHashKey('prop_till_03')] = {
        [1] = {
            ['Name'] = 'Winkel',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-shopping-basket"></i>',
            ['EventName'] = 'fw-stores:server:open:shop',
        },
    },
    -- Dumpsters
    [GetHashKey('prop_cs_dumpster_01a')] = {
        [1] = {
            ['Name'] = 'Prullenbak Graaien',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-dumpster"></i>',
            ['EventName'] = 'fw-materials:client:search:trash',
        },
    },
    [GetHashKey('prop_dumpster_02a')] = {
        [1] = {
            ['Name'] = 'Prullenbak Graaien',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-dumpster"></i>',
            ['EventName'] = 'fw-materials:client:search:trash',
        },
    },
    [GetHashKey('prop_dumpster_01a')] = {
        [1] = {
            ['Name'] = 'Prullenbak Graaien',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-dumpster"></i>',
            ['EventName'] = 'fw-materials:client:search:trash',
        },
    },
    [GetHashKey('prop_dumpster_02b')] = {
        [1] = {
            ['Name'] = 'Prullenbak Graaien',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-dumpster"></i>',
            ['EventName'] = 'fw-materials:client:search:trash',
        },
    },
    [GetHashKey('prop_dumpster_4b')] = {
        [1] = {
            ['Name'] = 'Prullenbak Graaien',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-dumpster"></i>',
            ['EventName'] = 'fw-materials:client:search:trash',
        },
    },
    [GetHashKey('prop_dumpster_3a')] = {
        [1] = {
            ['Name'] = 'Prullenbak Graaien',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-dumpster"></i>',
            ['EventName'] = 'fw-materials:client:search:trash',
        },
    },
    [GetHashKey('prop_bin_05a')] = {
        [1] = {
            ['Name'] = 'Prullenbak Graaien',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-dumpster"></i>',
            ['EventName'] = 'fw-materials:client:search:trash',
        },
    },
    -- BurgerShot
    [GetHashKey('v_ind_bin_01')] = {
        [1] = {
            ['Job'] = 'burger',
            ['UseDuty'] = true,
            ['Name'] = 'Kassa',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-coins"></i>',
            ['EventName'] = 'fw-burgershot:client:open:register',
        },
        [2] = {
            ['Name'] = 'Betalen',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-coins"></i>',
            ['EventName'] = 'fw-burgershot:client:open:payment',
        },
    },
    [GetHashKey('prop_food_bs_tray_01')] = {
        [1] = {
            ['Name'] = 'Dienblad',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-utensils"></i>',
            ['EventName'] = 'fw-burgershot:client:open:tray',
            ['EventParameter'] = 1,
        },
    },
    [GetHashKey('prop_food_bs_tray_02')] = {
        [1] = {
            ['Name'] = 'Dienblad',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-utensils"></i>',
            ['EventName'] = 'fw-burgershot:client:open:tray',
            ['EventParameter'] = 2,
        },
    },
    [GetHashKey('v_ind_cf_chickfeed')] = {
        ['Job'] = 'burger',
        ['UseDuty'] = true,
        [1] = {
            ['Name'] = 'Warmte Bak',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-hamburger"></i>',
            ['EventName'] = 'fw-burgershot:client:open:hot:storage',
        },
    },
    [GetHashKey('v_ret_gc_bag01')] = {
        ['Job'] = 'burger',
        ['UseDuty'] = true,
        [1] = {
            ['Name'] = 'Vlees Bakken',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-drumstick-bite"></i>',
            ['EventName'] = 'fw-burgershot:client:bake:meat',
        },
    },
    [GetHashKey('v_ret_gc_bag02')] = {
        ['Job'] = 'burger',
        ['UseDuty'] = true,
        [1] = {
            ['Name'] = 'Friet Bakken',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-drumstick-bite"></i>',
            ['EventName'] = 'fw-burgershot:client:bake:fries',
        },
    },
    [GetHashKey('v_ilev_fib_frame03')] = {
        ['Job'] = 'burger',
        ['UseDuty'] = true,
        [1] = {
            ['Name'] = 'Koeling Opslag',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-boxes"></i>',
            ['EventName'] = 'fw-burgershot:client:open:cold:storage',
        },
    },
    [GetHashKey('v_ilev_fib_frame02')] = {
        ['Job'] = 'burger',
        ['UseDuty'] = true,
        [1] = {
            ['Name'] = 'Softdrink Maken',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-wine-bottle"></i>',
            ['EventName'] = 'fw-burgershot:client:create:drink',
            ['EventParameter'] = 'burger-softdrink',
        },
        [2] = {
            ['Name'] = 'Koffie Maken',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-wine-bottle"></i>',
            ['EventName'] = 'fw-burgershot:client:create:drink',
            ['EventParameter'] = 'burger-coffee',
        },
    },
    [GetHashKey('v_ilev_m_sofacushion')] = {
        ['Job'] = 'burger',
        [1] = {
            ['Name'] = 'In / Uit Klokken',
            ['EventType'] = 'Server',
            ['Logo'] = '<i class="fas fa-user-clock"></i>',
            ['EventName'] = 'Framework:ToggleDuty',
        },
    },
    [GetHashKey('v_ret_fh_pot01')] = {
        ['Job'] = 'burger',
        ['UseDuty'] = true,
        [1] = {
            ['Name'] = 'Bleeder Maken',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-hamburger"></i>',
            ['EventName'] = 'fw-burgershot:client:create:burger',
            ['EventParameter'] = 'burger-bleeder',
        },
        [2] = {
            ['Name'] = 'Heartstopper Maken',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-hamburger"></i>',
            ['EventName'] = 'fw-burgershot:client:create:burger',
            ['EventParameter'] = 'burger-heartstopper',
        },
        [3] = {
            ['Name'] = 'Moneyshot Maken',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-hamburger"></i>',
            ['EventName'] = 'fw-burgershot:client:create:burger',
            ['EventParameter'] = 'burger-moneyshot',
        },
        [4] = {
            ['Name'] = 'Torpedo Maken',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-hamburger"></i>',
            ['EventName'] = 'fw-burgershot:client:create:burger',
            ['EventParameter'] = 'burger-torpedo',
        },
    },
    [GetHashKey('v_ilev_m_sofacushion')] = {
        ['Job'] = 'burger',
        [1] = {
            ['Name'] = 'In / Uit Klokken',
            ['EventType'] = 'Server',
            ['Logo'] = '<i class="fas fa-user-clock"></i>',
            ['EventName'] = 'Framework:ToggleDuty',
        },
    },
    [GetHashKey('s_m_m_highsec_02')] = {
        ['Job'] = 'burger',
        [1] = {
            ['Name'] = 'Bonnetjes Inleveren',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-receipt"></i>',
            ['EventName'] = 'fw-illegal:client:talk:to:npc',
        },
    },
}

Config.VehicleMenu = {
    [1] = {
        ['Name'] = 'Kofferbak',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-truck-loading"></i>',
        ['EventName'] = 'fw-eye:client:open:trunk',
    },
    [2] = {
        ['Name'] = 'Kofferbak Liggen',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-couch"></i>',
        ['EventName'] = 'fw-eye:client:getin:trunk',
    },
}

Config.CarDealerVehicleMenu = {
    [1] = {
        ['Name'] = 'Kofferbak',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-truck-loading"></i>',
        ['EventName'] = 'fw-eye:client:open:trunk',
    },
    [2] = {
        ['Name'] = 'Kofferbak Liggen',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-couch"></i>',
        ['EventName'] = 'fw-eye:client:getin:trunk',
    },
    [3] = {
        ['Name'] = 'Voertuig Verkopen',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-file-signature"></i>',
        ['EventName'] = 'fw-cardealer:client:sell:closest:vehicle',
    },
}

Config.PedMenu = {
    [1] = {
        ['Name'] = 'Bán hàng hóa',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-handshake"></i>',
        ['EventName'] = 'fw-illegal:client:sell:to:ped',
    }, 
}

Config.VehicleOFfsets = {
    [0]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.5, ['Z-Offset'] = 0.0},
    [1]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -2.0, ['Z-Offset'] = 0.0},
    [2]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [3]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.5, ['Z-Offset'] = 0.0},
    [4]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -2.0, ['Z-Offset'] = 0.0},
    [5]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -2.0, ['Z-Offset'] = 0.0},
    [6]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -2.0, ['Z-Offset'] = 0.0},
    [7]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -2.0, ['Z-Offset'] = 0.0},
    [8]  = {['CanEnter'] = false, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.5, ['Z-Offset'] = 0.0},
    [9]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [10]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [11]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [12]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [13]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [14]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [15]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [16]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [17]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [18]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [19]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [20]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [21]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25}
}