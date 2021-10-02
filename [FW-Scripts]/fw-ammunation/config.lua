Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config = Config or {}

Config.Timeout = 30 * (60 * 1000)

Config.RequiredCops = 0

Config.AmmunationLocation = {
    ["coords"] = {
        ["x"] = 811.9,
        ["y"] = -2147.54,
        ["z"] = 29.5,
    }
}

Config.WhitelistedWeapons = {
    [GetHashKey("weapon_hatchet")] = {
        ["timeOut"] = 4000
    },
}

Config.VitrineRewards = {
    [1] = {
        ["item"] = "weapon_knife",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 1
        },
    },
    [2] = {
        ["item"] = "armor",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 3
        },
    },
    [3] = {
        ["item"] = "pistol-ammo",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 3
        },
    },
    [4] = {
        ["item"] = "snspistol_part_1",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 1
        },
    },
    [5] = {
        ["item"] = "snspistol_part_2",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 1
        },
    },
    [6] = {
        ["item"] = "snspistol_part_3",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 1
        },
    },
    [7] = {
        ["item"] = "handcuffs",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 1
        },
    },
}

Config.Locations = {
    [1] = {
        ["coords"] = {
            ["x"] = 812.58, 
            ["y"] = -2151.3, 
            ["z"] = 29.62,
        },
        ["isOpened"] = false,
        ["isBusy"] = false,
    }, 
    [2] = {
        ["coords"] = {
            ["x"] = 812.58, 
            ["y"] = -2153.49, 
            ["z"] = 29.62,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [3] = {
        ["coords"] = {
            ["x"] = 812.01, 
            ["y"] = -2157.69, 
            ["z"] = 29.62,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [4] = {
        ["coords"] = {
            ["x"] = 809.62, 
            ["y"] = -2156.99, 
            ["z"] = 29.62,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    },
    [5] = {
        ["coords"] = {
            ["x"] = 808.65, 
            ["y"] = -2154.95, 
            ["z"] = 29.62,
        },
        ["isOpened"] = false,
        ["isBusy"] = false,
    }, 
    [6] = {
        ["coords"] = {
            ["x"] = 810.24, 
            ["y"] = -2157.75, 
            ["z"] = 29.62,
        },
        ["isOpened"] = false,
        ["isBusy"] = false, 
    
    }
}

Config.MaleNoHandshoes = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [18] = true,
    [26] = true,
    [52] = true,
    [53] = true,
    [54] = true,
    [55] = true,
    [56] = true,
    [57] = true,
    [58] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [112] = true,
    [113] = true,
    [114] = true,
    [118] = true,
    [125] = true,
    [132] = true,
}

Config.FemaleNoHandshoes = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [19] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [63] = true,
    [64] = true,
    [65] = true,
    [66] = true,
    [67] = true,
    [68] = true,
    [69] = true,
    [70] = true,
    [71] = true,
    [129] = true,
    [130] = true,
    [131] = true,
    [135] = true,
    [142] = true,
    [149] = true,
    [153] = true,
    [157] = true,
    [161] = true,
    [165] = true,
}