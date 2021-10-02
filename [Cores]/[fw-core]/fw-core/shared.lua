Shared = {}

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

Shared.RandomStr = function(length)
	if length > 0 then
		return Shared.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Shared.RandomInt = function(length)
	if length > 0 then
		return Shared.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

Shared.SplitStr = function(str, delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( str, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( str, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( str, delimiter, from  )
	end
	table.insert( result, string.sub( str, from  ) )
	return result
end

Shared.Items = {
	-- // Unarmed \\ --
    ["weapon_unarmed"] 				 = {["name"] = "weapon_unarmed", 		 	  	["label"] = "Handen", 					["weight"] = 1000, 		["type"] = "weapon",	["ammotype"] = 'nil', 					["image"] = "placeholder.png", 	["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "This is a placeholder description"},
    ["weapon_fireextinguisher"]      = {["name"] = "weapon_fireextinguisher", 		["label"] = "Brandblusser", 			["weight"] = 1000, 		["type"] = "weapon",	["ammotype"] = 'AMMO_WATER', 			["image"] = "fireext.png",   	["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Een blusser voor brand?"},
	-- // Pistols \\ --
	["weapon_stungun"] 				 = {["name"] = "weapon_stungun", 				["label"] = "Taser X4", 				["weight"] = 5000, 		["type"] = "weapon", 	["ammotype"] = "AMMO_PISTOL",			["image"] = "stungun.png", 	      ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Een politie taser."},
	["weapon_combatpistol"] 		 = {["name"] = "weapon_combatpistol", 			["label"] = "Combat Pistol", 			["weight"] = 7000, 		["type"] = "weapon", 	["ammotype"] = "AMMO_PISTOL",			["image"] = "combatpistol.png",   ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Een pittig pistooltje wel hoor."},
	["weapon_pistol_mk2"] 			 = {["name"] = "weapon_pistol_mk2", 			["label"] = "Glock 17", 				["weight"] = 7000, 		["type"] = "weapon", 	["ammotype"] = "AMMO_PISTOL",			["image"] = "glock-17.png", 	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Een politie vuurwapen."},
	["weapon_snspistol_mk2"] 		 = {["name"] = "weapon_snspistol_mk2", 			["label"] = "Sns Pistol", 				["weight"] = 5000, 		["type"] = "weapon", 	["ammotype"] = "AMMO_PISTOL",			["image"] = "snspistol.png", 	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "De opvolger van de ewrten schieter alleen dan beter."},
	["weapon_heavypistol"] 			 = {["name"] = "weapon_heavypistol", 			["label"] = "Heavy Pistol", 			["weight"] = 12000, 	["type"] = "weapon", 	["ammotype"] = "AMMO_PISTOL",			["image"] = "heavypistol.png", 	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Een tering zwaar pistool."},
	["weapon_vintagepistol"] 		 = {["name"] = "weapon_vintagepistol", 		    ["label"] = "Classic Pistol", 			["weight"] = 7500,    	["type"] = "weapon", 	["ammotype"] = "AMMO_PISTOL",			["image"] = "vintage.png", 	      ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Een echt klassiek pistooltje."},
	-- // SMG Pistols \\ --
	["weapon_machinepistol"] 		 = {["name"] = "weapon_machinepistol", 		    ["label"] = "Machine Pistol", 			["weight"] = 12000, 	["type"] = "weapon", 	["ammotype"] = "AMMO_PISTOL",			["image"] = "machine.png", 	      ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Rattatatatataaaaaa."},
	["weapon_appistol"] 			 = {["name"] = "weapon_appistol", 			    ["label"] = "AP Pistol", 			    ["weight"] = 12000, 	["type"] = "weapon", 	["ammotype"] = "AMMO_PISTOL",			["image"] = "appistol.png", 	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Poah wat een vuur kracht."},
	-- // Shothguns \\ --
	["weapon_sawnoffshotgun"] 		 = {["name"] = "weapon_sawnoffshotgun", 		["label"] = "Sawnoff Shotgun", 			["weight"] = 15500, 	["type"] = "weapon", 	["ammotype"] = "AMMO_SHOTGUN",			["image"] = "sawnoff.png", 	      ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Dit is het echte werk."},
	-- // Rifles \\ --
	["weapon_carbinerifle_mk2"] 	 = {["name"] = "weapon_carbinerifle_mk2", 		["label"] = "Carbine Rifle",	 		["weight"] = 17000, 	["type"] = "weapon", 	["ammotype"] = "AMMO_RIFLE",			["image"] = "saltmaker.png", 	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Zoutig politie wapen."},
	["weapon_assaultrifle_mk2"] 	 = {["name"] = "weapon_assaultrifle_mk2", 		["label"] = "Assault Rifle",	 		["weight"] = 17000, 	["type"] = "weapon", 	["ammotype"] = "AMMO_RIFLE",			["image"] = "assaultrifle.png",   ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Ak's in the back."},
	-- // Melee \\ --
	["weapon_nightstick"] 			 = {["name"] = "weapon_nightstick", 			["label"] = "Police Baton", 			["weight"] = 3000,	 	["type"] = "weapon", 	["ammotype"] = 'nil',					["image"] = "baton.png", 		  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Een politie baton."},
	["weapon_flashlight"] 			 = {["name"] = "weapon_flashlight", 			["label"] = "Flashlight", 					["weight"] = 1350,	 	["type"] = "weapon", 	["ammotype"] = 'nil',					["image"] = "flashlight.png", 	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Schijn een lichtje op mij."},
	["weapon_hatchet"] 				 = {["name"] = "weapon_hatchet", 		 	  	["label"] = "Chopping axe", 					["weight"] = 4750, 		["type"] = "weapon", 	["ammotype"] = 'nil',		            ["image"] = "hatchet.png", 		  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Om hout mee te hakken of iets anders :D."},
	["weapon_switchblade"] 			 = {["name"] = "weapon_switchblade", 	 	  	["label"] = "Switchblade", 				["weight"] = 4750, 		["type"] = "weapon", 	["ammotype"] = 'nil',					["image"] = "switchblade.png",	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Een KLAP mes."},
	["weapon_knife"] 			 	 = {["name"] = "weapon_knife", 	 	  			["label"] = "Knife", 				["weight"] = 4750, 		["type"] = "weapon", 	["ammotype"] = 'nil',					["image"] = "wknife.png",	 	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Een mes."},
	["weapon_hammer"] 				 = {["name"] = "weapon_hammer", 			 	["label"] = "Hammer", 					["weight"] = 4750, 		["type"] = "weapon", 	["ammotype"] = 'nil',					["image"] = "hammer.png",         ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Hamertje tik spelen?"},
	["weapon_wrench"] 				 = {["name"] = "weapon_wrench", 			 	["label"] = "Wrench", 				["weight"] = 4750, 		["type"] = "weapon", 	["ammotype"] = 'nil',					["image"] = "wrench.png",         ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Deze sleutel past niet in je broek hoor."},
	["weapon_bread"] 				 = {["name"] = "weapon_bread", 		 			["label"] = "Bánh mì", 				["weight"] = 2550, 		["type"] = "weapon", 	["ammotype"] = 'nil',					["image"] = "baquette.png", 	  ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Een lekkere lange franse stok."},	
	["weapon_molotov"] 				 = {["name"] = "weapon_molotov", 		 		["label"] = "Molotov", 					["weight"] = 4550, 		["type"] = "weapon", 	["ammotype"] = 'nil',					["image"] = "molotov.png", 	      ["unique"] = true, 		["useable"] = false, 	["combinable"] = nil, ["description"] = "Cocktailtje lekker hoor."},
	
	-- // Ammo \\ --
	["pistol-ammo"] 				 = {["name"] = "pistol-ammo", 			 	  	["label"] = "Pistol ammo", 			["weight"] = 500, 		["type"] = "item", 		["image"] = "ammo-pistol.png", 			["unique"] = false, 			["useable"] = true, 	["shouldClose"] = true, ["combinable"] = nil,   ["description"] = "Pistool munitie."},
	["rifle-ammo"] 					 = {["name"] = "rifle-ammo", 			 	  	["label"] = "Rifle ammo", 			["weight"] = 700, 		["type"] = "item", 		["image"] = "ammo-rifle.png", 			["unique"] = false, 			["useable"] = true, 	["shouldClose"] = true, ["combinable"] = nil,   ["description"] = "Ik denk dat dit automatische geweer kogels zijn, Weet het alleen niet zeker..."},
	["smg-ammo"] 					 = {["name"] = "smg-ammo", 			 	  		["label"] = "SMG ammo", 				["weight"] = 650, 		["type"] = "item", 		["image"] = "ammo-smg.png", 			["unique"] = false, 			["useable"] = true, 	["shouldClose"] = true, ["combinable"] = nil,   ["description"] = "Semi-Automatische geweer kogels."},
	["shotgun-ammo"] 				 = {["name"] = "shotgun-ammo", 			 	  	["label"] = "Shotgun Shells", 			["weight"] = 650, 		["type"] = "item", 		["image"] = "ammo-shotgun.png", 		["unique"] = false, 			["useable"] = true, 	["shouldClose"] = true, ["combinable"] = nil,   ["description"] = "Shotguns Shells."},
	["taser-ammo"] 				 	 = {["name"] = "taser-ammo", 			 	  	["label"] = "Tazer Cartridge", 			["weight"] = 650, 		["type"] = "item", 		["image"] = "taser-ammo.png", 		    ["unique"] = false, 			["useable"] = true, 	["shouldClose"] = true, ["combinable"] = nil,   ["description"] = "Pasop dat je geen optater krijgt."},
	-- // Attatchments \\ --
	["pistol_suppressor"] 			 = {["name"] = "pistol_suppressor", 			["label"] = "Pistol Silencer", 			["weight"] = 1000, 		["type"] = "item", 		["image"] = "pistol_suppressor.png", 	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Wapen attatchement."},
	["pistol_extendedclip"] 		 = {["name"] = "pistol_extendedclip", 			["label"] = "Pistol EXT Clip", 			["weight"] = 1000, 		["type"] = "item", 		["image"] = "pistol_extendedclip.png", 	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Wapen attatchement."},
	
	["rifle_extendedclip"] 		 	 = {["name"] = "rifle_extendedclip", 			["label"] = "Rifle EXT Clip", 			["weight"] = 1000, 		["type"] = "item", 		["image"] = "rifle_extendedclip.png", 	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Wapen attatchement."},
	["rifle_flashlight"] 		 	 = {["name"] = "rifle_flashlight", 				["label"] = "Rifle Flashlight", 		["weight"] = 1000, 		["type"] = "item", 		["image"] = "rifle_flashlight.png", 	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Wapen attatchement."},
	["rifle_suppressor"] 			 = {["name"] = "rifle_suppressor", 				["label"] = "Rifle Silencer", 			["weight"] = 1000, 		["type"] = "item", 		["image"] = "rifle_suppressor.png", 	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Wapen attatchement."},
	["rifle_scope"] 			 	 = {["name"] = "rifle_scope", 					["label"] = "Rifle Scope", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "rifle_scope.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Wapen attatchement."},
	-- // Miscs \\ --
	-- // Items \\ --
	["handcuffs"] 					 = {["name"] = "handcuffs", 			 	  	["label"] = "Còng tay", 				["weight"] = 1250, 		["type"] = "item", 		["image"] = "cuffs.png", 				["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Om stoute stoute dingen mee te doen. (KEKW)"},
	["radio"] 						 = {["name"] = "radio", 			 	 		["label"] = "Bộ đàm", 					["weight"] = 1000, 		["type"] = "item", 		["image"] = "porto.png", 				["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Om mee over de ether te praten."},
	["police_stormram"] 			 = {["name"] = "police_stormram", 			 	["label"] = "Stormram", 				["weight"] = 7500, 		["type"] = "item", 		["image"] = "stormram.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Een storm ram om een huis mee in te rammen."},
	["empty_evidence_bag"] 			 = {["name"] = "empty_evidence_bag", 			["label"] = "Empty evidence bag", 		["weight"] = 0, 		["type"] = "item", 		["image"] = "evidence.png", 			["unique"] = false,     ["useable"] = false, 	["shouldClose"] = false,  ["combinable"] = nil,   ["description"] = "Wordt vaak gebruikt om bewijs materiaal in op te slaan. Denk aan DNA van bloed, kogelhulsen of haar etc."},
	["filled_evidence_bag"] 		 = {["name"] = "filled_evidence_bag", 			["label"] = "Evidence bag", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "evidence.png", 			["unique"] = true, 	    ["useable"] = false, 	["shouldClose"] = false,  ["combinable"] = nil,   ["description"] = "Een gevuld bewijs zakje."},	
	["bloodvial"] 					 = {["name"] = "bloodvial", 					["label"] = "Blood sample", 			["weight"] = 350, 		["type"] = "item", 		["image"] = "bloodvial.png", 			["unique"] = true, 	    ["useable"] = false, 	["shouldClose"] = false,  ["combinable"] = nil,   ["description"] = "Een medisch buisje met wat bloed druppels."},
	["armor"] 						 = {["name"] = "armor", 			 	  		["label"] = "Vest", 				["weight"] = 15000, 	["type"] = "item", 		["image"] = "vest.png", 				["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Een kogel afwerend vest."},
	["heavy-armor"] 				 = {["name"] = "heavy-armor", 			 	  	["label"] = "Heavy Vest", 				["weight"] = 20000, 	["type"] = "item", 		["image"] = "zwaar-vest.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Een zwaar kogel afwerend vest."},
	-- // Lockpicks     
	["lockpick"] 					 = {["name"] = "lockpick", 			 	 	 	["label"] = "Lockpick", 				["weight"] = 1000,  	["type"] = "item", 		["image"] = "lockpick.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = {accept = {"toolkit"}, reward = "advancedlockpick", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Lockpick maken..", ["timeOut"] = 7500,}},   ["description"] = "Een draadje ijzer verders niks speciaals"},
	["toolkit"] 					 = {["name"] = "toolkit", 			 			["label"] = "Toolkit", 					["weight"] = 450,  		["type"] = "item", 		["image"] = "toolkit.png", 				["unique"] = false,     ["useable"] = false, 	["shouldClose"] = false,  ["combinable"] = {accept = {"lockpick"}, reward = "advancedlockpick", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Lockpick maken..", ["timeOut"] = 7500,}},  ["description"] = "Een handige schroevendraaier set."},
	["repairkit"] 					 = {["name"] = "repairkit", 			 		["label"] = "Repair Kit", 				["weight"] = 2500,  	["type"] = "item", 		["image"] = "repairkit.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Een kistje vol met gereedschap."},
	["advancedlockpick"] 			 = {["name"] = "advancedlockpick", 			 	["label"] = "Advanced Lockpick", 			["weight"] = 1500,  	["type"] = "item", 		["image"] = "advlockpick.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Dit is geen draadje ijzer meer.."},
	["drill"] 				 		 = {["name"] = "drill", 			    		["label"] = "Drill Machine", 			["weight"] = 15000, 	["type"] = "item", 		["image"] = "drill.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Wat is dit voor een grote jonge."},
	["drill-bit"] 				 	 = {["name"] = "drill-bit", 			    	["label"] = "Drill Bit Machine", 				["weight"] = 1500, 		["type"] = "item", 		["image"] = "drill-bit.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,  ["combinable"] = nil,   ["description"] = "Een bitje voor op een boor neem ik aan."},
	
	-- // Cards \\ --
	["blue-card"] 			 		 = {["name"] = "blue-card", 			 		["label"] = "Blue Card", 			["weight"] = 1000,  	["type"] = "item", 		["image"] = "bank-blue.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Een blauw pasje.."},
	["purple-card"] 				 = {["name"] = "purple-card", 			 		["label"] = "Purple Card", 			["weight"] = 1000,  	["type"] = "item", 		["image"] = "bank-purple.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Een paars pasje.."},
	["red-card"] 					 = {["name"] = "red-card", 					 	["label"] = "Red Card", 				["weight"] = 1000,  	["type"] = "item", 		["image"] = "bank-red.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Een rood pasje.."},
	["green-card"] 					 = {["name"] = "green-card", 					["label"] = "Green Card", 			["weight"] = 1000,  	["type"] = "item", 		["image"] = "bank-green.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Een groen pasje.."},
	["yellow-card"] 				 = {["name"] = "yellow-card", 					["label"] = "Yellow Card", 				["weight"] = 1000,  	["type"] = "item", 		["image"] = "jewerly-yellow.png", 		["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Een geel pasje.."},
	["black-card"] 				 	 = {["name"] = "black-card", 					["label"] = "Black Card", 			["weight"] = 1000,  	["type"] = "item", 		["image"] = "bank-black.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Een zwart pasje.."},
	["electronickit"] 			   	 = {["name"] = "electronickit", 				["label"] = "Electronic Kit", 			["weight"] = 1000,  	["type"] = "item", 		["image"] = "electronickit.png", 		["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Een soort van moederbord?!?"},
	-- // Robbery Rewards \\ --
	["markedbills"] 				 = {["name"] = "markedbills", 			  	  	["label"] = "Inked Geld", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "markedbills.png", 			["unique"] = true, 		["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Een tasje met inkt?"},
	["gold-rolex"] 				 	 = {["name"] = "gold-rolex", 			  	  	["label"] = "Gold Rolex", 			["weight"] = 1500, 		["type"] = "item", 		["image"] = "gold-rolex.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Is dit een echte rolex of niet?"},
	["gold-necklace"] 				 = {["name"] = "gold-necklace", 			  	["label"] = "Gold Necklace", 			["weight"] = 1500, 		["type"] = "item", 		["image"] = "gold-necklace.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Wat een mooie gouden ketting is dit toch."},
	["gold-bar"] 			 	 	 = {["name"] = "gold-bar", 			  			["label"] = "Gold bar", 				["weight"] = 7000, 	    ["type"] = "item", 		["image"] = "gold-bar.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Dikke grote zware staaf van goud."},
	["diamond-ring"] 			 	 = {["name"] = "diamond-ring", 			  		["label"] = "Diamon Ring", 			["weight"] = 1250, 	    ["type"] = "item", 		["image"] = "diamond-ring.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Lijkt wel op een trouw ring of iets."},
	["diamond-blue"] 			 	 = {["name"] = "diamond-blue", 			  		["label"] = "Blue Diamond", 			["weight"] = 3500, 	    ["type"] = "item", 		["image"] = "diamond-blue.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Een blauwe diamant? Is die wel echt?"},
	["diamond-red"] 			 	 = {["name"] = "diamond-red", 			  		["label"] = "Red Diamond", 			["weight"] = 3500, 	    ["type"] = "item", 		["image"] = "diamond-red.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "En dan is er ook nog een rode??"},
	["stolen-tv"] 			 		 = {["name"] = "stolen-tv", 			  		["label"] = "Stolen TV", 			    ["weight"] = 80000, 	["type"] = "item", 		["image"] = "stolen-tv.png", 			["unique"] = true, 		["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Hier krijg je toch een hernia van?"},
	["stolen-pc"] 			 		 = {["name"] = "stolen-pc", 			  		["label"] = "Stolen Computer", 	    ["weight"] = 80000, 	["type"] = "item", 		["image"] = "stolen-pc.png", 			["unique"] = true, 		["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Kan ik hierop fivemmen?"},
	["stolen-micro"] 			 	 = {["name"] = "stolen-micro", 			  		["label"] = "Stolen Microwave", 	    ["weight"] = 80000, 	["type"] = "item", 		["image"] = "stolen-micro.png", 		["unique"] = true, 		["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Popcorn erbij heerluk."},

	["note"] 			 	 		 = {["name"] = "note", 			  				["label"] = "Sticky Note", 			["weight"] = 500, 	    ["type"] = "item", 		["image"] = "note.png", 				["unique"] = true,   	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Een leeg papiertje?"},
	
	["plastic"] 					 = {["name"] = "plastic", 			  	  	  	["label"] = "Plastic", 					["weight"] = 200, 		["type"] = "item", 		["image"] = "plastic.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Liever wel te recyclen :)"},
	["metalscrap"] 					 = {["name"] = "metalscrap", 			  	  	["label"] = "Metal Scrap", 			["weight"] = 200, 		["type"] = "item", 		["image"] = "metalscrap.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Hier kun je vast iets stevigs mee maken."},
	["copper"] 					 	 = {["name"] = "copper", 			  	  		["label"] = "Đồng", 					["weight"] = 200, 		["type"] = "item", 		["image"] = "copper.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Handig stukje metaal wat je vast wel kunt gebruiken."},
	["aluminum"] 					 = {["name"] = "aluminum", 			  	  		["label"] = "Nhôm", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "aluminum.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Handig stukje metaal wat je vast wel kunt gebruiken."},
	["iron"] 				 	     = {["name"] = "iron", 			  				["label"] = "Sắt", 					["weight"] = 200, 		["type"] = "item", 		["image"] = "ironplate.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Handig stukje metaal wat je vast wel kunt gebruiken."},
	["steel"] 				 	 	 = {["name"] = "steel", 			  			["label"] = "Thép", 					["weight"] = 200, 		["type"] = "item", 		["image"] = "steel.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Handig stukje metaal wat je vast wel kunt gebruiken."},
	["rubber"] 				 	 	 = {["name"] = "rubber", 			  			["label"] = "Cao su", 					["weight"] = 200, 		["type"] = "item", 		["image"] = "rubber.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Sappig stukje rubber om je naad mee te vegen.."},
	["glass"] 				 	 	 = {["name"] = "glass", 			  			["label"] = "Thủy tinh", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "glassplate.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Het is nogal breekbaar.. Kijk uit."},
	
	["rifle-body"] 				 	 = {["name"] = "rifle-body", 			  		["label"] = "Rifle Body", 				["weight"] = 700, 		["type"] = "item", 		["image"] = "rifle-body.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Een wapen onderdeel of iets?"},
	["rifle-clip"] 				 	 = {["name"] = "rifle-clip", 			  		["label"] = "Rifle Clip", 				["weight"] = 700, 		["type"] = "item", 		["image"] = "rifle-clip.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Een wapen onderdeel of iets?"},
	["rifle-stock"] 				 = {["name"] = "rifle-stock", 			  		["label"] = "Rifle Stock", 				["weight"] = 700, 		["type"] = "item", 		["image"] = "rifle-stock.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Een wapen onderdeel of iets?"},
	["rifle-trigger"] 				 = {["name"] = "rifle-trigger", 			  	["label"] = "Rifle Trigger", 			["weight"] = 700, 		["type"] = "item", 		["image"] = "rifle-trigger.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Een wapen onderdeel of iets?"},

	["ironoxide"] 				 	 = {["name"] = "ironoxide", 			  		["label"] = "Bột sắt", 			["weight"] = 100, 		["type"] = "item", 		["image"] = "ironoxide.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = {accept = {"aluminumoxide"}, reward = "thermite", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Poeders mixen..", ["timeOut"] = 10000}},   ["description"] = "Wat poeder om mee te mixen."},
	["aluminumoxide"] 				 = {["name"] = "aluminumoxide", 			  	["label"] = "Bột nhôm", 		["weight"] = 100, 		["type"] = "item", 		["image"] = "aluminumoxide.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = {accept = {"ironoxide"}, reward = "thermite", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Poeders mixen..", ["timeOut"] = 10000}},   ["description"] = "Wat poeder om mee te mixen."},
	["thermite"] 			 	 	 = {["name"] = "thermite", 			  			["label"] = "Thermiet", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "thermite.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Wow dit is erg vlambaar.."},

	["coin"] 						 = {["name"] = "coin", 						  	["label"] = "Đồng xu may mắn", 	    	["weight"] = 100, 		["type"] = "item", 		["image"] = "coin.png", 		        ["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Een geluks muntje zal het jouw geluk geven??"},
	["dice"] 						 = {["name"] = "dice", 			  				["label"] = "Xúc xắc", 			["weight"] = 100, 		["type"] = "item", 		["image"] = "dice.png", 				["unique"] = true, 		["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Setje dobbel stenen lekker gokkuhh."},

	["bandage"] 					 = {["name"] = "bandage", 			  			["label"] = "Băng cứu thương", 					["weight"] = 100, 		["type"] = "item", 		["image"] = "bandage.png", 		        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Verband voor je kleine wondjes."},
	["painkillers"] 				 = {["name"] = "painkillers", 			  		["label"] = "Thuốc giảm đau", 				["weight"] = 100, 		["type"] = "item", 		["image"] = "painkillers.png", 		    ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Dit is best zware medicatie."},
	["lsd-strip"] 			     	 = {["name"] = "lsd-strip", 			  		["label"] = "Tem", 				["weight"] = 250, 		["type"] = "item", 		["image"] = "postzegel.png", 		    ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Lekker likken."},
	["joint"] 						 = {["name"] = "joint", 			  	    	["label"] = "Joint", 					["weight"] = 200, 		["type"] = "item", 		["image"] = "joint.png", 		        ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Een jonko voor op de lip."},
	["health-pack"] 				 = {["name"] = "health-pack", 			    	["label"] = "Bộ sơ cứu", 				["weight"] = 6000,   	["type"] = "item", 		["image"] = "health-pack.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Lijkt erop dat je iemand hiermee kan helpen.."},

	["wet-tak"] 					 = {["name"] = "wet-tak", 			  	    	["label"] = "Lá cần tươi", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "wet-tak.png", 		        ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Een wet tak?!?"},
	["wet-bud"] 					 = {["name"] = "wet-bud", 			  	    	["label"] = "Lá cần khô", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "wet-bud.png", 		        ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"rolling-paper"}, reward = "joint", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Bezig met joint draaien..", ["timeOut"] = 5000,}},   ["description"] = "Wat is al dit wet gedoe toch?"},
	["plastic-bag"] 				 = {["name"] = "plastic-bag", 			  	    ["label"] = "Plastic Zakje", 			["weight"] = 200, 		["type"] = "item", 		["image"] = "plastic-bag.png", 		    ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Een plastic zakje om iets in te doen ?"},
	["weed-nutrition"] 				 = {["name"] = "weed-nutrition", 			  	["label"] = "Planten Voeding", 			["weight"] = 4500, 		["type"] = "item", 		["image"] = "nutrition.png", 		    ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Even lekker opdrinken of niet?"},
	["weed_white-widow"] 			 = {["name"] = "weed_white-widow", 			 	["label"] = "White Widow 2g", 			["weight"] = 200, 		["type"] = "item", 		["image"] = "weed-baggie.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Een zakje met een groene substantie."},
	["weed_skunk"] 				  	 = {["name"] = "weed_skunk", 			 		["label"] = "Skunk 2g", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "weed-baggie.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Een zakje met een groene substantie."},
	["weed_purple-haze"] 			 = {["name"] = "weed_purple-haze", 			 	["label"] = "Purple Haze 2g", 			["weight"] = 200, 		["type"] = "item", 		["image"] = "weed-baggie.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Een zakje met een groene substantie."},
	["weed_og-kush"] 				 = {["name"] = "weed_og-kush", 			 		["label"] = "OGKush 2g", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "weed-baggie.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Een zakje met een groene substantie."},
	["weed_amnesia"] 				 = {["name"] = "weed_amnesia", 			 		["label"] = "Amnesia 2g", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "weed-baggie.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Een zakje met een groene substantie."},
	["weed_ak47"] 				     = {["name"] = "weed_ak47", 			 		["label"] = "AK47 2g", 					["weight"] = 200, 		["type"] = "item", 		["image"] = "weed-baggie.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Een zakje met een groene substantie."},
	
	["weed-brick"] 				     = {["name"] = "weed-brick", 			 		["label"] = "Wiet Brick", 				["weight"] = 4000, 		["type"] = "item", 		["image"] = "weed-brick.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Een puur natuurlijk brickie."},
	["rolling-paper"] 			 	 = {["name"] = "rolling-paper", 			  	["label"] = "Vloei", 					["weight"] = 10, 		["type"] = "item", 		["image"] = "rolling-paper.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = {accept = {"wet-bud"}, reward = "joint", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Bezig met joint draaien..", ["timeOut"] = 5000,}},   ["description"] = "Shaggies rollen tot de dood."},

	["white-widow-seed"] 		 	= {["name"] = "white-widow-seed", 				["label"] = "White Widow Zaad", 		["weight"] = 10, 		["type"] = "item", 		["image"] = "plant-seed.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Een plantzaadje van White Widow"},
	["skunk-seed"] 				 	= {["name"] = "skunk-seed", 			    	["label"] = "Skunk Zaad", 				["weight"] = 10, 		["type"] = "item", 		["image"] = "plant-seed.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Een plantzaadje van Skunk"},
	["purple-haze-seed"] 		 	= {["name"] = "purple-haze-seed", 				["label"] = "Purple Haze Zaad", 		["weight"] = 10, 		["type"] = "item", 		["image"] = "plant-seed.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Een plantzaadje van Purple Haze"},
	["og-kush-seed"] 			 	= {["name"] = "og-kush-seed", 					["label"] = "OGKush Zaad", 				["weight"] = 10, 		["type"] = "item", 		["image"] = "plant-seed.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Een plantzaadje van OG Kush"},
	["amnesia-seed"] 			 	= {["name"] = "amnesia-seed", 					["label"] = "Amnesia Zaad", 			["weight"] = 10, 		["type"] = "item", 		["image"] = "plant-seed.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Een plantzaadje van Amnesia"},
	["ak47-seed"] 				 	= {["name"] = "ak47-seed", 			    		["label"] = "AK47 Zaad", 				["weight"] = 10, 		["type"] = "item", 		["image"] = "plant-seed.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Een plantzaadje van AK47"},
	
	["coke-bag"] 			     	= {["name"] = "coke-bag", 			  			["label"] = "Túi cocain", 			["weight"] = 250, 		["type"] = "item", 		["image"] = "coke-bag.png", 		    ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Grammetje coke joh."},
	["packed-coke-brick"] 			= {["name"] = "packed-coke-brick", 			    ["label"] = "Cocain đóng gói", 		["weight"] = 7500, 		["type"] = "item", 		["image"] = "packaged-brick.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Verpakte witte poeder?!?"},
	["pure-coke-brick"] 			= {["name"] = "pure-coke-brick", 			    ["label"] = "Khối Cocain nguyên chất", 		["weight"] = 4500, 		["type"] = "item", 		["image"] = "pure-coke-brick.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Volgensmij ziet cocaïne er niet zo uit toch?"},
	["coke-brick"] 					= {["name"] = "coke-brick", 			   		["label"] = "Khối Cocaine", 			["weight"] = 1550, 		["type"] = "item", 		["image"] = "coke-brick.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Ahh dit is pas echte cocaïne"},
	["coke-powder"] 				= {["name"] = "coke-powder", 			   		["label"] = "Bột Cocain", 			["weight"] = 250, 		["type"] = "item", 		["image"] = "coke-powder.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Poedersuiker?"},
	
	["meth-bag"] 					= {["name"] = "meth-bag", 			   			["label"] = "Túi Meth", 				["weight"] = 250, 		["type"] = "item", 		["image"] = "meth-bag.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Blauwe suiker?"},
	["meth-powder"] 				= {["name"] = "meth-powder", 			   		["label"] = "Bột Meth", 				["weight"] = 250, 		["type"] = "item", 		["image"] = "meth-powder.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Wat een mooie berg met blauwe poeder joh."},
	["meth-ingredient-1"] 			= {["name"] = "meth-ingredient-1", 			   	["label"] = "Nguyên liệu Meth", 			["weight"] = 2500, 		["type"] = "item", 		["image"] = "meth-ingredient-1.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Lijkt wel op een ingredient voor meth?"},
	["meth-ingredient-2"] 			= {["name"] = "meth-ingredient-2", 			   	["label"] = "Nguyên liệu Meth", 			["weight"] = 2500, 		["type"] = "item", 		["image"] = "meth-ingredient-2.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Dit lijkt ook wel op een ingredient voor meth?"},
	
	["burner-phone"] 			 	= {["name"] = "burner-phone", 			   		["label"] = "Burner Điện thoại", 			["weight"] = 1000, 		["type"] = "item", 		["image"] = "old-phone.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Een oude telefoon joh poah."},
	
	["money-paper"] 				= {["name"] = "money-paper", 			   		["label"] = "Tiền giấy", 				["weight"] = 4500, 		["type"] = "item", 		["image"] = "money-paper.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Sow een stapel papier moker zwaar."},
	["money-inkt"] 					= {["name"] = "money-inkt", 			   		["label"] = "Mực in tiền", 				["weight"] = 5400, 		["type"] = "item", 		["image"] = "money-inkt.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Als ik dit maar niet op mijn kleding krijg."},
	["money-roll"] 					= {["name"] = "money-roll", 			   		["label"] = "Cuộn tiền giấy", 			["weight"] = 25, 		["type"] = "item", 		["image"] = "money-roll.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Weer die rolletjes met geld joh.."},

	["key-a"] 				 		= {["name"] = "key-a", 			    			["label"] = "Chìa khóa A", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "key-a.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Sleutel A?"},
	["key-b"] 				 		= {["name"] = "key-b", 			    			["label"] = "Chìa khóa B", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "key-b.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Sleutel B?"},
	["key-c"] 				 		= {["name"] = "key-c", 			    			["label"] = "Chìa khóa C", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "key-c.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Sleutel C?"},
	
	["knife"] 				 		= {["name"] = "knife", 			    			["label"] = "Dao", 						["weight"] = 1250, 		["type"] = "item", 		["image"] = "knife.png", 				["unique"] = true, 		["useable"] = false, 	["shouldClose"] = true,	   ["combinable"] = {accept = {"pure-coke-brick"}, reward = "coke-brick", RemoveToItem = false, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Brick versnijden..", ["timeOut"] = 7500,}}, ["description"] = "Scherp messie wel hoor."},

	["lotto-card"] 					 = {["name"] = "lotto-card", 			 	  	["label"] = "Thẻ cào", 					["weight"] = 100,		["type"] = "item", 		["image"] = "lotto-card.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Krassen tot de dood.."},
	["used-card"] 					 = {["name"] = "used-card", 			 	  	["label"] = "Thẻ đã cào", 		    ["weight"] = 75,		["type"] = "item", 		["image"] = "used-card.png", 			["unique"] = true, 		["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Deze is al gekrast.."},

	-- // Food \\ --
	["phone"] 						 = {["name"] = "phone", 			 	  	  	["label"] = "Điện thoại", 				["weight"] = 750, 		["type"] = "item", 		["image"] = "phone.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Een stukje technologie"},
	["sandwich"] 					 = {["name"] = "sandwich", 			 	  	  	["label"] = "Bánh mì", 					["weight"] = 125, 		["type"] = "item", 		["image"] = "bread.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Een broodje met beleg."},
	["water"] 						 = {["name"] = "water", 			 	  	  	["label"] = "Nước suối", 					["weight"] = 125, 		["type"] = "item", 		["image"] = "water.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Eventjes lekker drinken."},
	["slushy"] 						 = {["name"] = "slushy", 			 	  	  	["label"] = "Nước ngọt", 					["weight"] = 125, 		["type"] = "item", 		["image"] = "slushy.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Pas op voor een brain freeze."},
	["ecola"] 						 = {["name"] = "ecola", 			 	  	  	["label"] = "Coca-Cola", 					["weight"] = 125, 		["type"] = "item", 		["image"] = "ecola.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Blikie cola lekker hoor."},
	["sprunk"] 						 = {["name"] = "sprunk", 			 	  	  	["label"] = "Sprite", 					["weight"] = 125, 		["type"] = "item", 		["image"] = "sprunk.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Sprunkie dr bij?"},
	["chocolade"] 					 = {["name"] = "chocolade", 			 	  	["label"] = "So-co-la", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "chocolade.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Een chocolade bar pasop straks word je nog dik."},
	["donut"] 						 = {["name"] = "donut", 			 	  	  	["label"] = "Bánh Donut", 					["weight"] = 125, 		["type"] = "item", 		["image"] = "donut.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Lekker donutje."},
	["coffee"] 				 		 = {["name"] = "coffee", 			  	  		["label"] = "Cà phê", 					["weight"] = 200, 		["type"] = "item", 		["image"] = "coffee.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Lekker voor in de ochtend."},
	["420-choco"] 				 	 = {["name"] = "420-choco", 			  	  	["label"] = "420 So-co-la", 			["weight"] = 200, 		["type"] = "item", 		["image"] = "420-choco.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "420?"},
	-- Burger Shot
	["burger-bleeder"] 				 = {["name"] = "burger-bleeder", 			 	["label"] = "Burger Bleeder", 					["weight"] = 250, 		["type"] = "item", 		["image"] = "burger-bleeder.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Sow beetje bloederig broodje of niet?"},
	["burger-moneyshot"] 			 = {["name"] = "burger-moneyshot", 			 	["label"] = "Burger Moneyshot", 				["weight"] = 300, 		["type"] = "item", 		["image"] = "burger-moneyshot.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Zit hier geld in ?"},
	["burger-torpedo"] 				 = {["name"] = "burger-torpedo", 			 	["label"] = "Burger Torpedo", 					["weight"] = 310, 		["type"] = "item", 		["image"] = "burger-torpedo.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Hoort dit niet in een onderzeeboot."},
	["burger-heartstopper"] 		 = {["name"] = "burger-heartstopper", 			["label"] = "Burger Heartstopper", 			["weight"] = 2500, 		["type"] = "item", 		["image"] = "burger-heartstopper.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Dit kan mijn hart niet aan hoor."},
	["burger-softdrink"] 			 = {["name"] = "burger-softdrink", 				["label"] = "Burger SoftDrink", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "burger-softdrink.png", 	["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Lekker slokkie nemen."},
	["burger-coffee"] 			     = {["name"] = "burger-coffee", 				["label"] = "Burger Coffee", 			["weight"] = 125, 		["type"] = "item", 		["image"] = "burger-coffee.png", 	    ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Pasop is heet!"},
	["burger-fries"] 				 = {["name"] = "burger-fries", 			 	  	["label"] = "Burger Khoai tây chiên", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "burger-fries.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Friet of patat? #ComeAtMe"},
	
	["burger-bun"] 				 	 = {["name"] = "burger-bun", 			 	  	["label"] = "Bánh mì Burger", 			["weight"] = 125, 		["type"] = "item", 		["image"] = "burger-bun.png", 		    ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Lekker warm en knapperig."},
	["burger-meat"] 				 = {["name"] = "burger-meat", 			 	  	["label"] = "Burger Thịt", 			["weight"] = 125, 		["type"] = "item", 		["image"] = "burger-meat.png", 		    ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Hmm lekker sappig stukkie vlees."},
	["burger-lettuce"] 				 = {["name"] = "burger-lettuce", 			 	["label"] = "Burger Rau", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "burger-lettuce.png", 	    ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Dit lijkt wel op vergif."},
	
	["burger-raw"] 				 	 = {["name"] = "burger-raw", 			 		["label"] = "Thịt sống", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "burger-raw.png", 	        ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Dit kan je niet eten hoor."},
	["burger-potato"] 				 = {["name"] = "burger-potato", 			 	["label"] = "Khoai tây chiên", 		["weight"] = 1500, 		["type"] = "item", 		["image"] = "burger-potato.png", 	    ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Lekker schillen."},
	
	["burger-ticket"] 				 = {["name"] = "burger-ticket", 			 	["label"] = "Burger Ticket", 	     	["weight"] = 150, 		["type"] = "item", 		["image"] = "burger-ticket.png", 	    ["unique"] = true,   	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Hier staat een bestelling op die snel gemaakt moet worden!"},
	["burger-box"] 				 	 = {["name"] = "burger-box", 			 	    ["label"] = "Burger Box", 	     	    ["weight"] = 1000, 		["type"] = "item", 		["image"] = "burger-box.png", 	        ["unique"] = true,   	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Hier zitten lekkere spulletjes in."},
	-- Unicorn    
	["cocktail-1"] 				 	= {["name"] = "cocktail-1", 			 	  	["label"] = "Cocktail", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "cocktail-1.png", 		    ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Oehhh een COCKtail."},
	["cocktail-2"] 				 	= {["name"] = "cocktail-2", 			 	  	["label"] = "Cocktail", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "cocktail-2.png", 		    ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Dit is wel heel erg roze."},
	["cocktail-3"] 				 	= {["name"] = "cocktail-3", 			 	  	["label"] = "Cocktail", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "cocktail-3.png", 		    ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Ziet er wel lekker en tropisch uit."},

	-- Fishing
	["fishrod"] 					 = {["name"] = "fishrod", 			 	  	  	["label"] = "Cần câu", 		    	["weight"] = 500, 		["type"] = "item", 		["image"] = "vishengel.png", 			["unique"] = true, 	    ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Even lekker hengelen.."},
	["fish-1"] 						 = {["name"] = "fish-1", 			 	  	  	["label"] = "Cá xanh", 				["weight"] = 750, 		["type"] = "item", 		["image"] = "fish-1.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Dit is bijna een goudvis.."},
	["fish-2"] 						 = {["name"] = "fish-2", 			 	  	  	["label"] = "Cá rô", 					["weight"] = 1500, 		["type"] = "item", 		["image"] = "fish-2.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Pas op ik kan prikken.."},
	["fish-3"] 						 = {["name"] = "fish-3", 			 	  	  	["label"] = "Cá thu", 					["weight"] = 2000, 		["type"] = "item", 		["image"] = "fish-3.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Watn joekel van een vis zeg."},
	["plasticbag"] 					 = {["name"] = "plasticbag", 			 	 	["label"] = "Túi nhựa", 				["weight"] = 125, 		["type"] = "item", 		["image"] = "plasticbag.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Zak over de hoofd en gaan, toch??"},
	["shoe"] 						 = {["name"] = "shoe", 			 	     	  	["label"] = "Giày cũ", 				["weight"] = 1500, 		["type"] = "item", 		["image"] = "shoe.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Sportief moddeletje wel hoor."},

	["id-card"] 					 = {["name"] = "id-card", 			 	  	  	["label"] = "Thẻ căn cước", 		["weight"] = 100, 		["type"] = "item", 		["image"] = "license-id.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Een kaart waar al je gegevens op staat."},
	["drive-card"] 			    	 = {["name"] = "drive-card", 		    	  	["label"] = "Giấy phép lái xe", 				["weight"] = 100, 		["type"] = "item", 		["image"] = "license-drive.png", 		["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Bewijs om aan te tonen dat je een voertuig kunt besturen."},
	["lawyerpass"] 					 = {["name"] = "lawyerpass", 			 	  	["label"] = "Thẻ luật sư", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "lawyerpass.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Pas enkel voor advocaten als bewijs dat zij een verdachte mogen vertegenwoordigen."},
	["duffel-bag"] 					 = {["name"] = "duffel-bag", 			 	  	["label"] = "Túi đựng", 			    ["weight"] = 19500, 	["type"] = "item", 		["image"] = "duffel-bag.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Sow deze is tering zwaar."},

	-- SJ Performance
	["tunerlaptop"] 				 = {["name"] = "tunerlaptop", 			 	 	["label"] = "Tuner Chip", 				["weight"] = 500,  	    ["type"] = "item", 		["image"] = "tunerlaptop.png", 			["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "SJ Performance TunerLaptop"},
	["nitrous"] 				     = {["name"] = "nitrous", 			 	 	    ["label"] = "Nitro", 				    ["weight"] = 500,  	    ["type"] = "item", 		["image"] = "nitrous.png", 			    ["unique"] = false,     ["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Nitro Produced By SJ Performance"},
	
	-- Messen Onderdelen
	["knife-part-1"] 				 = {["name"] = "knife-part-1", 			 	  	["label"] = "Mảnh dao", 			["weight"] = 450, 		["type"] = "item", 		["image"] = "knife-part-1.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"knife-part-2"}, reward = "weapon_knife", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Combineren..", ["timeOut"] = 7500,}},   ["description"] = "Lijkt wel op een onderdeel van een mes."},
	["knife-part-2"] 				 = {["name"] = "knife-part-2", 			 	  	["label"] = "Mảnh dao", 			["weight"] = 450, 		["type"] = "item", 		["image"] = "knife-part-2.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"knife-part-1"}, reward = "weapon_knife", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Combineren..", ["timeOut"] = 7500,}},   ["description"] = "Lijkt wel op een onderdeel van een mes."},
	["switch-part-1"] 				 = {["name"] = "switch-part-1", 			 	["label"] = "Mảnh cán dao", 	["weight"] = 450, 		["type"] = "item", 		["image"] = "switch-part-1.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"switch-part-2"}, reward = "weapon_switchblade", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Combineren..", ["timeOut"] = 7500,}},   ["description"] = "Lijkt wel op een onderdeel van een mes."},
	["switch-part-2"] 				 = {["name"] = "switch-part-2", 			 	["label"] = "Mảnh cán dao", 	["weight"] = 450, 		["type"] = "item", 		["image"] = "switch-part-2.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"switch-part-1"}, reward = "weapon_switchblade", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Combineren..", ["timeOut"] = 7500,}},   ["description"] = "Lijkt wel op een onderdeel van een mes."},

	["snspistol_part_1"] 			 = {["name"] = "snspistol_part_1", 				["label"] = "SNS Loop", 				["weight"] = 1500, 		["type"] = "item", 		["image"] = "snspistol_part_1.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"snspistol_part_3"}, reward = "snspistol_stage_1", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Onderdelen aan het bevestigen", ["timeOut"] = 15000,}},   ["description"] = "Loop van een SNS Pistol"},
	["snspistol_part_2"] 			 = {["name"] = "snspistol_part_2", 				["label"] = "SNS Trigger", 				["weight"] = 1500, 		["type"] = "item", 		["image"] = "snspistol_part_2.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"snspistol_stage_1"}, reward = "weapon_snspistol_mk2", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Onderdelen aan het bevestigen", ["timeOut"] = 15000,}},   ["description"] = "Trigger van een SNS Pistol"},
	["snspistol_part_3"] 			 = {["name"] = "snspistol_part_3", 				["label"] = "SNS Clip", 				["weight"] = 1500, 		["type"] = "item", 		["image"] = "snspistol_part_3.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"snspistol_part_1"}, reward = "snspistol_stage_1", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Onderdelen aan het bevestigen", ["timeOut"] = 15000,}},   ["description"] = "Clip van een SNS Pistol"},
	["snspistol_stage_1"] 			 = {["name"] = "snspistol_stage_1", 			["label"] = "SNS Body", 				["weight"] = 2500, 		["type"] = "item", 		["image"] = "snspistol_stage_1.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = true,    ["combinable"] = {accept = {"snspistol_part_2"}, reward = "weapon_snspistol_mk2", RemoveToItem = true, anim = {["dict"] = "amb@world_human_clipboard@male@idle_a", ["lib"] = "idle_c", ["text"] = "Onderdelen aan het bevestigen", ["timeOut"] = 15000,}}, ["description"] = "SNS w/ Loop & Clip"},
}

Shared.Vehicles = {
 	-- // Sports \ --
 ['schafter3'] =    {['Price'] = 67000,  ['Name'] = 'Benefactor Schafter V12'},
 ['sultan'] =       {['Price'] = 50000,  ['Name'] = 'Karin Sultan'},
 ['sultanrs'] =     {['Price'] = 70000,  ['Name'] = 'Karin SultanRS'},
 ['elegy'] =        {['Price'] = 63000,  ['Name'] = 'Annis Elegy'},
 ['carbonizzare'] = {['Price'] = 80000,  ['Name'] = 'Grotti Carbonzzare'},
 ['comet3'] =       {['Price'] = 112000, ['Name'] = 'Pfister Comet Sports'},
 ['jester'] =       {['Price'] = 125000, ['Name'] = 'Dinka Jester'},
 ['stinger'] =      {['Price'] = 135000, ['Name'] = 'Grotti Stinger'},
 ['adder'] =        {['Price'] = 650000, ['Name'] = 'Truffade Adder'},
 -- // Sedans \ --
 ['premier'] =  {['Price'] = 12500,  ['Name'] = 'Declasse Premier'},
 ['primo2'] =   {['Price'] = 22500,  ['Name'] = 'Albany Primo'},
 ['superd'] =   {['Price'] = 125000, ['Name'] = 'Enus Super Diamond'},
 ['stafford'] = {['Price'] = 30000,  ['Name'] = 'Enus Stafford'},
 ['glendale'] = {['Price'] = 14500,  ['Name'] = 'Benefactor Glendale'},
 ['intruder'] = {['Price'] = 15000,  ['Name'] = 'Karin Intruder'},
 ['emperor2'] = {['Price'] = 7500,   ['Name'] = 'Albany Emperor'},
 ['weevil'] =   {['Price'] = 31500,  ['Name'] = 'BF Weevil'},
 ['brioso2'] =  {['Price'] = 29500,  ['Name'] = 'Grotti Brioso'},
 -- // Motors \ --
 ['akuma'] =    {['Price'] = 21500,  ['Name'] = 'Dinka Akuma'},
 ['bati'] =     {['Price'] = 22500,  ['Name'] = 'Pegassi Bati'},
 ['bagger'] =   {['Price'] = 9750,   ['Name'] = 'Western Bagger'},
 ['bf400'] =    {['Price'] = 15500,  ['Name'] = 'Nagasaki BF400'},
 ['carbonrs'] = {['Price'] = 20000,  ['Name'] = 'Nagasaki CarbonRS'},
 ['double'] =   {['Price'] = 19750,  ['Name'] = 'Dinka Double'},
 ['faggio'] =   {['Price'] = 2000,   ['Name'] = 'Pegassi Faggio'},
 ['manchez2'] = {['Price'] = 27500,  ['Name'] = 'Maibatsu Manchez'},
 -- // Muscle \ --
 ['buccaneer2'] = {['Price'] = 23000,  ['Name'] = 'Albany Buccaneer'},
 ['dominator'] =  {['Price'] = 21000,  ['Name'] = 'Vapid Dominator'},
 ['chino'] =      {['Price'] = 22500,  ['Name'] = 'Vapid Chino'},
 ['dukes'] =      {['Price'] = 18500,  ['Name'] = 'Imponte Dukes'},
 ['faction2'] =   {['Price'] = 23750,  ['Name'] = 'Willard Faction'},
 ['moonbeam2'] =  {['Price'] = 27950,  ['Name'] = 'Declasse Moonbeam'},
 ['btype'] =      {['Price'] = 82500,  ['Name'] = 'Albany Roosevelt'},
 ['btype2'] =     {['Price'] = 125000, ['Name'] = 'Albany Franken Strange'},
 ['btype3'] =     {['Price'] = 95000,  ['Name'] = 'Albany Roosevelt Valor'},
 ['manana'] =     {['Price'] = 25500,  ['Name'] = 'Albany Manana'},
 -- // Vans \ --
 ['bison'] =    {['Price'] = 23000,  ['Name'] = 'Bravado Bison'},
 ['minivan'] =  {['Price'] = 25400,  ['Name'] = 'Vapid Minivan'},
 ['bobcatxl'] = {['Price'] = 26970,  ['Name'] = 'Vapid Bobcat XL'},
 ['youga'] =    {['Price'] = 21500,  ['Name'] = 'Bravado Youga'},
 ['sandking'] = {['Price'] = 23750,  ['Name'] = 'Vapid Sandking'},
 ['toros'] =    {['Price'] = 90000,  ['Name'] = 'Pegassi Toros'},
 ['winky'] =    {['Price'] = 25750,  ['Name'] = 'Vapid Winky'},
 ['dubsta'] =   {['Price'] = 145000, ['Name'] = 'Benefactor Dubsta'},
 -- // Addon \ --
 ['911turbos'] = {['Price'] = 175000, ['Name'] = 'Porsche 911'},
 ['bmci'] =      {['Price'] = 250000, ['Name'] = 'BMW M5 F90'},
 ['rapide'] =    {['Price'] = 320000, ['Name'] = 'Aston Martin Rapide'},
 ['audirs6tk'] = {['Price'] = 285000, ['Name'] = 'Audi RS6 C7'},
 ['g632019'] =   {['Price'] = 350000, ['Name'] = 'Mercedes-Benz G63 AMG'},
 ['trhawk'] =    {['Price'] = 245000, ['Name'] = 'Jeep Track Hawk'},
 ['rmodgt63'] =  {['Price'] = 1, ['Name'] = 'Mercedes GT63'},
 ['rmodx6'] =    {['Price'] = 1, ['Name'] = 'BMW X6M'},
 ['mk1rabbit'] = {['Price'] = 45000, ['Name'] = 'MK1 Rabbit'},
 ['golf4'] =     {['Price'] = 75000, ['Name'] = 'Golf 4'},
 ['ek9'] =       {['Price'] = 65000, ['Name'] = 'Honda Civic'},
 ['s15'] =       {['Price'] = 110000, ['Name'] = 'Nissan Silvia'},
 ['gtr'] =       {['Price'] = 110000, ['Name'] = 'Nissan GTR'},
 ['skyline'] =   {['Price'] = 110000, ['Name'] = 'Nissan Skyline'},
 ['lwgtr'] =   	 {['Price'] = 110000, ['Name'] = 'Nissan LWGTR'},
 ['G632019'] =   {['Price'] = 110000, ['Name'] = 'Mercedes G63'},
}
	
Shared.StarterItems = {
  ["phone"] = {amount = 1, item = "phone"},
  ["id-card"] = {amount = 1, item = "id-card"},
  ["drive-card"] = {amount = 1, item = "drive-card"},
  ["water"] = {amount = 10, item = "water"},
  ["sandwich"] = {amount = 10, item = "sandwich"},
}

Shared.Jobs = {
	["unemployed"] = {
		label = "Thất nghiệp",
		payment = 25,
		defaultDuty = true,
	},
	["taxi"] = {
		label = "Taxi",
		payment = 50,
		defaultDuty = true,
	},
	["tow"] = {
		label = "Bergnet",
		payment = 50,
		defaultDuty = true,
	},
	["reporter"] = {
		label = "Phóng viên",
		payment = 50,
		defaultDuty = true,
	},
	["garbage"] = {
		label = "Nhân viên dọn rác",
		payment = 50,
		defaultDuty = true,
	},
	["burger"] = {
		label = "Nhân viên Burgershot",
		payment = 50,
		defaultDuty = false,
	},
	["police"] = {
		label = "Cảnh sát",
		payment = 300,
		defaultDuty = true,
	},
	["ambulance"] = {
		label = "Cứu thương",
		payment = 350,
		defaultDuty = true,
	},
	["judge"] = {
		label = "Thẩm phán",
		payment = 450,
		defaultDuty = true,
	},
	["lawyer"] = {
		label = "Luật sư",
		payment = 250,
		defaultDuty = true,
	},
	["realestate"] = {
		label = "Bất động sản",
		payment = 200,
		defaultDuty = true,
	},
	["cardealer"] = {
		label = "Bán xe",
		payment = 250,
		defaultDuty = true,
	},
	["sjperformance"] = {
		label = "SJ Performance",
		payment = 100,
		defaultDuty = true,
	},
}