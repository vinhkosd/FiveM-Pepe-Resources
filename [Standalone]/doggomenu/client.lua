local doggoMenuControl = 110

local bigDogAnimations = {
	{ dictionary = "creatures@rottweiler@amb@sleep_in_kennel@", animation = "sleep_in_kennel", name = "Lay Down", },
	{ dictionary = "creatures@rottweiler@amb@world_dog_barking@idle_a", animation = "idle_a", name = "Bark", },
	{ dictionary = "creatures@rottweiler@amb@world_dog_sitting@base", animation = "base", name = "Sit", },
	{ dictionary = "creatures@rottweiler@amb@world_dog_sitting@idle_a", animation = "idle_a", name = "Itch", },
	{ dictionary = "creatures@rottweiler@indication@", animation = "indicate_high", name = "Draw Attention", },
	{ dictionary = "creatures@rottweiler@melee@", animation = "dog_takedown_from_back", name = "Attack", },
	{ dictionary = "creatures@rottweiler@melee@streamed_taunts@", animation = "taunt_02", name = "Taunt", },
	{ dictionary = "creatures@rottweiler@tricks@", animation = "beg_loop", name = "Beg", },
	{ dictionary = "creatures@rottweiler@tricks@", animation = "paw_right_loop", name = "Shake Paw", },
	{ dictionary = "creatures@rottweiler@tricks@", animation = "petting_chop", name = "Receiving Pats", },
}

local smallDogAnimations = {
	{ dictionary = "creatures@pug@amb@world_dog_sitting@idle_a", animation = "idle_a", name = "Itch" },
	{ dictionary = "creatures@pug@amb@world_dog_sitting@idle_a", animation = "idle_b", name = "Sit" },
	{ dictionary = "creatures@pug@amb@world_dog_sitting@idle_a", animation = "idle_c", name = "Lay Down" },
	{ dictionary = "creatures@pug@amb@world_dog_barking@idle_a", animation = "idle_c", name = "Shake" },
	{ dictionary = "creatures@pug@amb@world_dog_barking@idle_a", animation = "idle_a", name = "Bark" },
	{ dictionary = "creatures@pug@move", animation = "idle_turn_0", name = "Dance" },
	{ dictionary = "creatures@pug@move", animation = "dead_right", name = "Sleep/Death 1" },
	{ dictionary = "creatures@pug@move", animation = "dead_left", name = "Sleep/Death 2" },

}

local bigDogModels = {
	"a_c_shepherd", "a_c_rottweiler", "a_c_husky", "a_c_retriever", "a_c_chop"
}

local smallDogModels = {
	"a_c_poodle", "a_c_pug", "a_c_westy"
}

-- Create a list of all dog models from both lists
local dogModels = {}
for _, value in pairs(bigDogModels) do
	dogModels[#dogModels + 1] = value
end
for _, value in pairs(smallDogModels) do
	dogModels[#dogModels + 1] = value
end

local emotePlaying = false

function isDog()
	local playerModel = GetEntityModel(GetPlayerPed(-1))
	for i=1, #dogModels, 1 do
		if GetHashKey(dogModels[i]) == playerModel then
			return true
		end
	end
	return false
end

function isSmallDog()
	local playerModel = GetEntityModel(GetPlayerPed(-1))
	for i=1, #smallDogModels, 1 do
		if GetHashKey(smallDogModels[i]) == playerModel then
			return true
		end
	end
	return false
end

function cancelEmote()
	ClearPedTasksImmediately(GetPlayerPed(-1))
	emotePlaying = false
end

function playAnimation(dictionary, animation)
	if emotePlaying then
		cancelEmote()
	end
	RequestAnimDict(dictionary)
	while not HasAnimDictLoaded(dictionary) do
		Wait(1)
	end
	TaskPlayAnim(GetPlayerPed(-1), dictionary, animation, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	emotePlaying = true
end

Citizen.CreateThread(function()
	WarMenu.CreateMenu('dogmenu', 'Doggo')

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('dogmenu') then
			local animations = (isSmallDog() and smallDogAnimations or bigDogAnimations)

			for i=1, #animations, 1 do
				if WarMenu.Button(animations[i].name) then
					playAnimation(animations[i].dictionary, animations[i].animation)
				end
			end
			if WarMenu.Button('Exit') then
				WarMenu.CloseMenu()
			end

			WarMenu.Display()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not WarMenu.IsMenuOpened('dogmenu') and IsControlJustReleased(0, doggoMenuControl) and isDog() then
			WarMenu.OpenMenu('dogmenu')
		end
		if emotePlaying then
			if (IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35)) then
				cancelEmote()
			end
		end
	end
end)

RegisterCommand('dogmenu', function(source, args, raw)
	if not WarMenu.IsMenuOpened('dogmenu') and isDog() then
		WarMenu.OpenMenu('dogmenu')
	end
end, false)
