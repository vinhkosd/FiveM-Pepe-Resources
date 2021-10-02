Framework = {}
Framework.PlayerData = {}
Framework.Config = Config
Framework.Shared = Shared
Framework.ServerCallbacks = {}

isLoggedIn = false

function GetCoreObject()
	return Framework
end

RegisterNetEvent('Framework:GetObject')
AddEventHandler('Framework:GetObject', function(cb)
	cb(GetCoreObject())
end)

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
	ShutdownLoadingScreenNui()
	exports.spawnmanager:setAutoSpawn(false)
	isLoggedIn = true
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)