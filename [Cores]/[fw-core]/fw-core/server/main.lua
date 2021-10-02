Framework = {}
Framework.Config = Config
Framework.Shared = Shared
Framework.ServerCallbacks = {}
Framework.UseableItems = {}

function GetCoreObject()
	return Framework
end

RegisterServerEvent('Framework:GetObject')
AddEventHandler('Framework:GetObject', function(cb)
	cb(GetCoreObject())
end)