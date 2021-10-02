Config = {}

Config.Money = {}
Config.Server = {} 
Config.Player = {}
Config.Server.PermissionList = {} 

Config.MaxPlayers = GetConvarInt('sv_maxclients', 64) 
Config.IdentifierType = "steam" 
Config.DefaultSpawn = {x=-1035.71,y=-2731.87,z=12.86,a=0.0}
Config.Money.MoneyTypes = {['cash'] = 500, ['bank'] = 7500, ['crypto'] = 0 }
Config.Money.DontAllowMinus = {'cash', 'crypto'}
Config.Server.whitelist = false 
Config.Server.discord = "Niks"
Config.Player.MaxWeight = 130000
Config.Player.MaxInvSlots = 25

Config.Player.Bloodtypes = {
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
}