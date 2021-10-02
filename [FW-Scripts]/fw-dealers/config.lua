Config = Config or {}

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

Config.RandomStr = function(length)
	if length > 0 then
		return Config.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Config.RandomInt = function(length)
	if length > 0 then
		return Config.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

Config.Dealers = {
    [1] = {
        ['Name'] = 'Oma Gerda',
        ['Type'] = 'medic-dealer',
        ['Coords'] = 'GA HET LEKKER ZOEKEN JOH',
        ['Products'] = {
            [1] = {
                name = "painkillers",
                price = 450,
                amount = 50,
                resetamount = 50,
                info = {},
                type = "item",
                slot = 1,
            },
            [2] = {
                name = "health-pack",
                price = 4500,
                amount = 5,
                resetamount = 5,
                info = {},
                type = "item",
                slot = 2,
            },
        },
    },
    [2] = {
        ['Name'] = 'Rachid',
        ['Type'] = 'weapon-dealer',
        ['Coords'] = 'GA HET LEKKER ZOEKEN JOH',
        ['Products'] = {
            [1] = {
                name = "weapon_switchblade",
                price = 3500,
                amount = 10,
                resetamount = 10,
                info = {
                    melee = true,
                    quality = 100.0,
                },
                type = "weapon",
                slot = 1,
            },
            [2] = {
                name = "weapon_hatchet",
                price = 4500,
                amount = 10,
                resetamount = 10,
                info = {
                    melee = true,
                    quality = 100.0,
                },
                type = "weapon",
                slot = 2,
            },
        },
    },
    [3] = {
        ['Name'] = 'Achmed',
        ['Type'] = 'weapon-dealer',
        ['Coords'] = 'GA HET LEKKER ZOEKEN JOH',
        ['Products'] = {
            [1] = {
                name = "weapon_wrench",
                price = 3500,
                amount = 10,
                resetamount = 10,
                info = {
                    melee = true,
                    quality = 100.0,
                },
                type = "weapon",
                slot = 1,
            },
            [2] = {
                name = "weapon_hammer",
                price = 3500,
                amount = 10,
                resetamount = 10,
                info = {
                    melee = true,
                    quality = 100.0,
                },
                type = "weapon",
                slot = 2,
            },
        },
    },
    [4] = {
        ['Name'] = 'Vladimir',
        ['Type'] = 'weapon-dealer',
        ['Coords'] = 'GA HET LEKKER ZOEKEN JOH',
        ['Products'] = {
            [1] = {
                name = "weapon_vintagepistol",
                price = 9500,
                amount = 2,
                resetamount = 2,
                info = {
                    melee = false,
                    serie = "",
                    quality = 100.0,
                },
                type = "weapon",
                slot = 1,
            },
            [2] = {
                name = "weapon_heavypistol",
                price = 15000,
                amount = 2,
                resetamount = 1,
                info = {
                    melee = false,
                    serie = "",
                    quality = 100.0,
                },
                type = "weapon",
                slot = 2,
            },
        },
    },
}