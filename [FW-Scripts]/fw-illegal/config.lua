Config = Config or {}

-- // Coke Lab \\ --

Config.CookTimer = 250

Config.ExplosionChance = 25

Config.PedInteraction = {
    [1] = {
        ['Name'] = 'Tyrone',
        ['Model'] = 'a_m_m_og_boss_01',
        ['Animation'] = "WORLD_HUMAN_SMOKING_POT",
        ['InteractAnimation'] = {
            ['AnimDict'] = 'mp_ped_interaction',
            ['AnimName'] = 'handshake_guy_a',
        },
        ['Coords'] = {
          ['X'] = 'Ga maar zoeken..',
          ['Y'] = 'Ga maar zoeken..',
          ['Z'] = 'Ga maar zoeken..',
          ['H'] = 'Ga maar zoeken..',
        },
        ['Products'] = {
            [1] = {
                name = "joint",
                price = 115,
                amount = 10,
                info = {},
                type = "item",
                slot = 1,
            },
        },
        ['CurrentPedNumber'] = nil,
    },
    [2] = {
        ['Name'] = 'Tyries',
        ['Model'] = 'a_m_m_og_boss_01',
        ['Animation'] = "WORLD_HUMAN_SMOKING_POT",
        ['InteractAnimation'] = {
            ['AnimDict'] = 'mp_ped_interaction',
            ['AnimName'] = 'handshake_guy_a',
        },
        ['Coords'] = {
          ['X'] = 'Ga maar zoeken..',
          ['Y'] = 'Ga maar zoeken..',
          ['Z'] = 'Ga maar zoeken..',
          ['H'] = 'Ga maar zoeken..',
        },
        ['Products'] = {
            [1] = {
                name = "key-a",
                price = 2500,
                amount = 2,
                info = {},
                type = "item",
                slot = 1,
            },
        },
        ['CurrentPedNumber'] = nil,
    },
    [3] = {
        ['Name'] = 'Dodge',
        ['Model'] = 'a_m_m_og_boss_01',
        ['Animation'] = "WORLD_HUMAN_SMOKING_POT",
        ['InteractAnimation'] = {
            ['AnimDict'] = 'mp_ped_interaction',
            ['AnimName'] = 'kisses_guy_a',
        },
        ['Coords'] = {
          ['X'] = 'Ga maar zoeken..',
          ['Y'] = 'Ga maar zoeken..',
          ['Z'] = 'Ga maar zoeken..',
          ['H'] = 'Ga maar zoeken..',
        },
        ['Products'] = {
            [1] = {
                name = "key-b",
                prie = 2500,
                amount = 2,
                info = {},
                type = "item",
                slot = 1,
            },
        },
        ['CurrentPedNumber'] = nil,
    },
    [4] = {
        ['Name'] = 'Dwayne',
        ['Model'] = 'a_m_m_og_boss_01',
        ['Animation'] = "WORLD_HUMAN_SMOKING_POT",
        ['InteractAnimation'] = {
            ['AnimDict'] = 'mp_ped_interaction',
            ['AnimName'] = 'kisses_guy_a',
        },
        ['Coords'] = {
          ['X'] = 'Ga maar zoeken..',
          ['Y'] = 'Ga maar zoeken..',
          ['Z'] = 'Ga maar zoeken..',
          ['H'] = 'Ga maar zoeken..',
        },
        ['Products'] = {
            [1] = {
                name = "key-c",
                price = 2500,
                amount = 2,
                info = {},
                type = "item",
                slot = 1,
            },
        },
        ['CurrentPedNumber'] = nil,
    },
    [5] = {
        ['Name'] = 'Coke',
        ['Model'] = 'mp_m_meth_01',
        ['Animation'] = "WORLD_HUMAN_CLIPBOARD",
        ['InteractAnimation'] = nil,
        ['Coords'] = {
          ['X'] = 1087.39,
          ['Y'] = -3199.20,
          ['Z'] = -38.99,
          ['H'] = 316.66,
        },
        ['Products'] = {
            [1] = {
                name = "knife",
                price = 150,
                amount = 10,
                info = {},
                type = "item",
                slot = 1,
            },
        },
        ['CurrentPedNumber'] = nil,
    },
    [6] = {
        ['Name'] = 'Meth',
        ['Model'] = 'mp_m_meth_01',
        ['Animation'] = "WORLD_HUMAN_CLIPBOARD",
        ['InteractAnimation'] = nil,
        ['Coords'] = {
          ['X'] = 998.02,
          ['Y'] = -3200.37,
          ['Z'] = -38.99,
          ['H'] = 312.53,
        },
        ['Products'] = {
            [1] = {
                name = "meth-ingredient-1",
                price = 350,
                amount = 25,
                info = {},
                type = "item",
                slot = 1,
            },
        },
        ['CurrentPedNumber'] = nil,
    },
    [7] = {
        ['Name'] = 'Achmed',
        ['Model'] = 'a_m_m_og_boss_01',
        ['Animation'] = "WORLD_HUMAN_SMOKING_POT",
        ['InteractAnimation'] = {
            ['AnimDict'] = 'mp_ped_interaction',
            ['AnimName'] = 'handshake_guy_a',
        },
        ['Coords'] = {
          ['X'] = 'Ga maar zoeken..',
          ['Y'] = 'Ga maar zoeken..',
          ['Z'] = 'Ga maar zoeken..',
          ['H'] = 'Ga maar zoeken..',
        },
        ['Products'] = {
            [1] = {
                name = "burner-phone",
                price = 750,
                amount = 25,
                info = {},
                type = "item",
                slot = 1,
            },
        },
        ['CurrentPedNumber'] = nil,
    },
    [8] = {
        ['Name'] = 'Richard',
        ['Model'] = 'cs_nervousron',
        ['Animation'] = "WORLD_HUMAN_CLIPBOARD",
        ['InteractAnimation'] = nil,
        ['Coords'] = {
          ['X'] = 1116.18,
          ['Y'] = -3193.46,
          ['Z'] = -40.39,
          ['H'] = 258.78,
        },
        ['Products'] = {
            [1] = {
                name = "money-inkt",
                price = 350,
                amount = 25,
                info = {},
                type = "item",
                slot = 1,
            },
        },
        ['CurrentPedNumber'] = nil,
    },
    [9] = {
        ['Name'] = 'Slotenmaker',
        ['Model'] = 'cs_old_man1a',
        ['Animation'] = "WORLD_HUMAN_CLIPBOARD",
        ['InteractAnimation'] = nil,
        ['Coords'] = {
          ['X'] = 170.00,
          ['Y'] = -1799.54,
          ['Z'] = 29.31,
          ['H'] = 315.65,
        },
        ['Products'] = nil,
        ['CurrentPedNumber'] = nil,
    },
    [10] = {
        ['Name'] = 'Toolshop1',
        ['Model'] = 's_m_m_gardener_01',
        ['Animation'] = "WORLD_HUMAN_CLIPBOARD",
        ['InteractAnimation'] = nil,
        ['Coords'] = {
          ['X'] = 46.45,
          ['Y'] = -1749.53,
          ['Z'] = 29.63,
          ['H'] = 43.75,
        },
        ['Products'] = nil,
        ['CurrentPedNumber'] = nil,
    },
    [11] = {
        ['Name'] = 'Toolshop2',
        ['Model'] = 's_m_m_gardener_01',
        ['Animation'] = "WORLD_HUMAN_CLIPBOARD",
        ['InteractAnimation'] = nil,
        ['Coords'] = {
          ['X'] = 2748.08,
          ['Y'] = -3472.64,
          ['Z'] = 55.67,
          ['H'] = 245.64,
        },
        ['Products'] = nil,
        ['CurrentPedNumber'] = nil,
    },
    [12] = {
        ['Name'] = 'Bank',
        ['Model'] = 's_m_m_highsec_02',
        ['Animation'] = "WORLD_HUMAN_CLIPBOARD",
        ['InteractAnimation'] = nil,
        ['Coords'] = {
          ['X'] = 241.35,
          ['Y'] = 225.22,
          ['Z'] = 106.28,
          ['H'] = 161.56,
        },
        ['Products'] = nil,
        ['CurrentPedNumber'] = nil,
    },
    [13] = {
        ['Name'] = 'Visser',
        ['Model'] = 'a_f_m_prolhost_01',
        ['Animation'] = "",
        ['InteractAnimation'] = nil,
        ['Coords'] = {
          ['X'] = -1686.35,
          ['Y'] = -1072.63,
          ['Z'] = 13.15,
          ['H'] = 52.82,
        },
        ['Products'] = nil,
        ['CurrentPedNumber'] = nil,
    },
    [14] = {
        ['Name'] = 'SellElectronics',
        ['Model'] = 'cs_beverly',
        ['Animation'] = "WORLD_HUMAN_CLIPBOARD",
        ['InteractAnimation'] = nil,
        ['Coords'] = {
          ['X'] = 'Ga maar zoeken..',
          ['Y'] = 'Ga maar zoeken..',
          ['Z'] = 'Ga maar zoeken..',
          ['H'] = 'Ga maar zoeken..',
        },
        ['Products'] = nil,
        ['CurrentPedNumber'] = nil,
    },
}

Config.Labs = {
    [1] = {
        ['Name'] = 'Methlab',
        ['KeyName'] = 'key-a',
        ['Cooking'] = false,
        ['Ingredient-Count'] = 0,
        ['Ingredients'] = {
            ['meth-ingredient-1'] = false,
            ['meth-ingredient-2'] = false,
        },
        ['Inventory'] = {},
        ['Coords'] = {
            ['Enter'] = {
              ['X'] = 'Veel plezier met zoeken..',
              ['Y'] = 'Veel plezier met zoeken..',
              ['Z'] = 'Veel plezier met zoeken..',
            },
            ['Exit'] = {
              ['X'] = 996.83,
              ['Y'] = -3200.64,
              ['Z'] = -36.39,
            },
            ['Action'] = {
              ['X'] = 1005.76,
              ['Y'] = -3200.38,
              ['Z'] = -38.51,
            },
        },
    },
    [2] = {
        ['Name'] = 'Cokelab',
        ['KeyName'] = 'key-b',
        ['Inventory'] = {},
        ['Coords'] = {
            ['Enter'] = {
              ['X'] = 'Veel plezier met zoeken..',
              ['Y'] = 'Veel plezier met zoeken..',
              ['Z'] = 'Veel plezier met zoeken..',
            },
            ['Exit'] = {
              ['X'] = 1088.71,
              ['Y'] = -3187.48,
              ['Z'] = -38.99,
            },
            ['Action'] = {
              ['X'] = 1099.62,
              ['Y'] = -3194.24,
              ['Z'] = -38.99,
            },
        },
    },
    [3] = {
        ['Name'] = 'Money Printer',
        ['KeyName'] = 'key-c',
        ['Paper-Count'] = 0,
        ['Inkt-Count'] = 0,
        ['Total-Money'] = 0,
        ['Coords'] = {
            ['Enter'] = {
              ['X'] = 'Veel plezier met zoeken..',
              ['Y'] = 'Veel plezier met zoeken..',
              ['Z'] = 'Veel plezier met zoeken..',
            },
            ['Exit'] = {
              ['X'] = 1138.15,
              ['Y'] = -3199.10,
              ['Z'] = -39.66,
            },
            ['ActionOne'] = {
              ['X'] = 1135.85,
              ['Y'] = -3198.36,
              ['Z'] = -39.42,
            },
            ['ActionTwo'] = {
              ['X'] = 1131.41,
              ['Y'] = -3198.34,
              ['Z'] = -39.42,
            },
            ['ActionThree'] = {
              ['X'] = 1126.18,
              ['Y'] = -3198.32,
              ['Z'] = -39.42,
            },
        },
    },
}

Config.RandomLocation = {
    [1] = {
        ['Name'] = '',
        ['Amount'] = 0,
        ['ItemName'] = '',
        ['Street'] = 'Power Street',
        ['Coords'] = {
          ['X'] = 114.69,
          ['Y'] = -1038.61,
          ['Z'] = 29.28
        },
    },
    [2] = {
        ['Name'] = '',
        ['Amount'] = 0,
        ['ItemName'] = '',
        ['Street'] = 'Jamestown Street',
        ['Coords'] = {
          ['X'] = 434.80,
          ['Y'] = -1906.58,
          ['Z'] = 25.91
        },
    },
    [3] = {
        ['Name'] = '',
        ['Amount'] = 0,
        ['ItemName'] = '',
        ['Street'] = 'Eiland',
        ['Coords'] = {
          ['X'] = -2167.06,
          ['Y'] = 5193.79,
          ['Z'] = 16.53
        },
    },
    [4] = {
        ['Name'] = '',
        ['Amount'] = 0,
        ['ItemName'] = '',
        ['Street'] = 'Toilet',
        ['Coords'] = {
          ['X'] = 1470.16,
          ['Y'] = 6550.30,
          ['Z'] = 14.90
        },
    },
    [5] = {
        ['Name'] = '',
        ['Amount'] = 0,
        ['ItemName'] = '',
        ['Street'] = 'Vuurtoren',
        ['Coords'] = {
          ['X'] = 3426.93,
          ['Y'] = 5174.61,
          ['Z'] = 7.4
        },
    },
    [6] = {
        ['Name'] = '',
        ['Amount'] = 0,
        ['ItemName'] = '',
        ['Street'] = 'Tackle Street',
        ['Coords'] = {
          ['X'] = -776.89,
          ['Y'] = -1323.20,
          ['Z'] = 5.15
        },
    },
}

-- // Corner Selling \\ --

Config.IsCornerSelling = true

Config.CornerSellingData = {
    ['Coords'] = {
      ['X'] = -178.0, 
      ['Y'] = -892.60, 
      ['Z'] = 29.33
    },
    ['Times'] = {
      ['Start'] = 1,
      ['End'] = 6,
    },
}

Config.MethCrafting = {
    [1] = {
      name = "meth-bag",
      amount = 150,
      info = {},
      costs = {
        ["meth-powder"] = 2,
        ["plastic-bag"] = 1,
      },
      type = "item",
      slot = 1,
      description = '[2x Meth Poeder, 1x Plastic Zakje]', 
    },
}

Config.CokeCrafting = {
    [1] = {
      name = "coke-bag",
      amount = 150,
      info = {},
      costs = {
        ["coke-powder"] = 2,
        ["plastic-bag"] = 1,
      },
      type = "item",
      slot = 1,
      description = '[2x Cocaïne Poeder, 1x Plastic Zakje]', 
    },
}

Config.SellDrugs = {
 ['weed_white-widow'] = {
     ['SellAMount'] = 7,
 },
 ['weed_skunk']= {
     ['SellAMount'] = 15,
 },
 ['weed_purple-haze']= {
     ['SellAMount'] = 23,
 },
 ['weed_og-kush']= {
     ['SellAMount'] = 35,
 },
 ['weed_amnesia']= {
     ['SellAMount'] = 48,
 },
 ['weed_ak47']= {
     ['SellAMount'] = 60,
 },
 ['coke-bag']= {
     ['SellAMount'] = 90,
 },
 ['meth-bag']= {
     ['SellAMount'] = 120,
 },
}

Config.AllowedItems = {
    ["coke-brick"] = {
       ['Name'] = "coke-brick",
       ['Wait'] = 60000,
       ['Reward-Amount'] = math.random(20, 25),
       ['Success'] = 'coke-powder',
       ['ToSlot'] = 2,
       ['Force'] = true,
    },
}