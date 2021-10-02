Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback("fw-banking:server:get:private:account", function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    Framework.Functions.ExecuteSql(false, "SELECT * FROM characters_accounts", function(result) 
        local AccountData = {}
        if result ~= nil then
            for k, v in pairs(result) do
                if v.type == 'private' then
                    if v.citizenid == Player.PlayerData.citizenid then
                        DatabaseData = {
                            Owner = v.citizenid,
                            Name = v.name,
                            BankId = v.bankid,
                            Balance = v.balance,
                        }
                        table.insert(AccountData, DatabaseData)
                    end
                end
            end
            cb(AccountData)
        end
    end)
end)

Framework.Functions.CreateCallback("fw-banking:server:get:shared:account", function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    Framework.Functions.ExecuteSql(true, "SELECT * FROM characters_accounts", function(result) 
        local AccountData = {}
        if result ~= nil then
            for k, v in pairs(result) do
                if v.type == 'shared' then
                    local AuthData = json.decode(v.authorized)
                    for Auth, Authorized in pairs(AuthData) do
                        if Authorized == Player.PlayerData.citizenid then
                            DatabaseData = {
                                Owner = v.citizenid,
                                Name = v.name,
                                BankId = v.bankid,
                                Balance = v.balance,
                            }
                            table.insert(AccountData, DatabaseData)
                        end
                    end
                end
            end
            cb(AccountData)
        end
    end)
end)

Framework.Functions.CreateCallback("fw-banking:server:get:account:users", function(source, cb, bankid)
    local Player = Framework.Functions.GetPlayer(source)
    Framework.Functions.ExecuteSql(false, "SELECT * FROM characters_accounts WHERE `bankid` = '"..bankid.."'", function(result) 
        local UserData = {}     
         if result ~= nil then
             for k, v in pairs(result) do 
                 local AuthorizedData = json.decode(v.authorized)
                 for Auth, Authorized in pairs(AuthorizedData) do
                     Framework.Functions.ExecuteSql(true, "SELECT * FROM characters_metadata WHERE `citizenid` = '"..Authorized.."'", function(CharResult) 
                         local DecodeCharInfo = json.decode(CharResult[1].charinfo)
                         AccountArrayData = {
                          Firstname = DecodeCharInfo.firstname,
                          Lastname = DecodeCharInfo.lastname,
                          CitizenId = Authorized,
                         }
                         table.insert(UserData, AccountArrayData)
                     end)
                 end
             end
             cb(UserData)
         end                 
    end)
end)

Framework.Functions.CreateCallback("fw-banking:server:get:account:transactions", function(source, cb, bankid)
    Framework.Functions.ExecuteSql(false, "SELECT * FROM characters_accounts WHERE `bankid` = '"..bankid.."'", function(result)
        local ReturnData = {}
        local TransactionData = json.decode(result[1].transactions)
         for k, v in pairs(TransactionData) do
             Transactions = {
                 Name = GetCharName(v.CitizenId),
                 Amount = v.Amount,
                 Type = v.Type,
                 CitizenId = v.CitizenId,
                 Date = v.Date,
                 Time = v.Time,
             }
             table.insert(ReturnData, Transactions)
         end
         cb(ReturnData)
    end)
end)

RegisterServerEvent('fw-banking:server:withdraw')
AddEventHandler('fw-banking:server:withdraw', function(RemoveAmount, BankId)
    local src = source
    local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.charinfo.account ~= BankId then
        local Balance = GetAccountBalance(BankId)
        local Amount = tonumber(RemoveAmount)
        local NewBalance = Balance - Amount
        if Balance >= Amount then
         Player.Functions.AddMoney('cash', Amount, 'Bank Opnemen')
         TriggerEvent('fw-banking:server:add:transaction', src, BankId, Amount, 'Remove')
         Framework.Functions.ExecuteSql(false, "UPDATE characters_accounts SET `balance` = '" .. NewBalance .. "' WHERE `bankid` = '" ..BankId.. "'")
        end
    else
        local CurrentBalance = Player.PlayerData.money['bank']
        local Amount = tonumber(RemoveAmount)
        if CurrentBalance >= Amount then
            Player.Functions.RemoveMoney('bank', Amount, 'Bank Opnemen')
            Player.Functions.AddMoney('cash', Amount, 'Bank Opnemen')
        else
            TriggerClientEvent('fw-banking:client:send:notify', source, 'Bank', 'error', 'Onvoldoende saldo..')
        end
    end
end)

RegisterServerEvent('fw-banking:server:deposit')
AddEventHandler('fw-banking:server:deposit', function(AddAmount, BankId)
    local src = source
    local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.charinfo.account ~= BankId then
        local Balance = GetAccountBalance(BankId)
        local CurrentCash = Player.PlayerData.money['cash']
        local Amount = tonumber(AddAmount)
        local NewBalance = Balance + Amount
        if CurrentCash >= Amount then
         Player.Functions.RemoveMoney('cash', Amount, 'Bank Storting')  
         TriggerEvent('fw-banking:server:add:transaction', src, BankId, Amount, 'Add')
         Framework.Functions.ExecuteSql(false, "UPDATE characters_accounts SET `balance` = '" .. NewBalance .. "' WHERE `bankid` = '" ..BankId.. "'")
        end
    else
        local CurrentCash = Player.PlayerData.money['cash']
        local Amount = tonumber(AddAmount)
        if CurrentCash >= Amount then
            Player.Functions.RemoveMoney('cash', Amount, 'Bank Storting')
            Player.Functions.AddMoney('bank', Amount, 'Bank Storting')
        else
            TriggerClientEvent('fw-banking:client:send:notify', source, 'Bank', 'error', 'Onvoldoende cash..')
        end
    end
end)

RegisterServerEvent('fw-banking:server:create:account')
AddEventHandler('fw-banking:server:create:account', function(AccountName, AccountType)
local Player = Framework.Functions.GetPlayer(source)
local RandomAccountId = CreateRandomIban()
 Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_accounts` (`citizenid`, `type`, `name`, `bankid`, `authorized`) VALUES ('"..Player.PlayerData.citizenid.."', '"..AccountType.."', '"..AccountName.."', '"..RandomAccountId.."', '[\""..Player.PlayerData.citizenid.."\"]')")
 TriggerClientEvent('fw-banking:client:refresh:bank', source)
end)

RegisterServerEvent('fw-banking:server:add:user')
AddEventHandler('fw-banking:server:add:user', function(BankId, TargetBsn)
    local src = source
    Framework.Functions.ExecuteSql(false, "SELECT * FROM characters_accounts WHERE `bankid` = '"..BankId.."'", function(result)
        if result ~= nil then
            local Count = 0
            local UserData = json.decode(result[1].authorized)
            local NewUsers = {}
            for k, v in pairs(UserData) do
                Count = Count + 1
                table.insert(NewUsers, v)
            end
            if Count < 5 then
             table.insert(NewUsers, TargetBsn)
             Framework.Functions.ExecuteSql(false, "UPDATE characters_accounts SET `authorized` = '" .. json.encode(NewUsers) .. "' WHERE `bankid` = '" ..BankId.. "'")
             TriggerClientEvent('fw-banking:client:refresh:bank', src)
            else
             TriggerClientEvent('Framework:Notify', src, "Je kan maximaal 4 burgers toevoegen..", 'error', 6500)
            end
        end
    end)
end)

RegisterServerEvent('fw-banking:server:remove:user')
AddEventHandler('fw-banking:server:remove:user', function(BankId, TargetBsn)
    local src = source
    Framework.Functions.ExecuteSql(false, "SELECT * FROM characters_accounts WHERE `bankid` = '"..BankId.."'", function(result)
        if result ~= nil then
            local UserData = json.decode(result[1].authorized)
            local NewUsers = {}
            for k, v in pairs(UserData) do
                if v ~= TargetBsn then
                 table.insert(NewUsers, v)
                end
            end
            Framework.Functions.ExecuteSql(false, "UPDATE characters_accounts SET `authorized` = '" .. json.encode(NewUsers) .. "' WHERE `bankid` = '" ..BankId.. "'")
            TriggerClientEvent('fw-banking:client:refresh:bank', src)
        end
    end)
end)

RegisterServerEvent('fw-banking:server:add:transaction')
AddEventHandler('fw-banking:server:add:transaction', function(Source, BankId, Amount, Type)
    local src = Source
    local Player = Framework.Functions.GetPlayer(src)
    Framework.Functions.ExecuteSql(false, "SELECT * FROM characters_accounts WHERE `bankid` = '"..BankId.."'", function(result)
        if result ~= nil then
            local NewTransactionData = {}
            local TransactionData = json.decode(result[1].transactions)
            local AddTransaction = {Type = Type, Amount = Amount, CitizenId = Player.PlayerData.citizenid, Date = os.date('%d-'..'%m-'..'%y'), Time = os.date('%H:'..'%M')}
            for k, v in pairs(TransactionData) do
                table.insert(NewTransactionData, v)
            end
            table.insert(NewTransactionData, AddTransaction)
            Framework.Functions.ExecuteSql(false, "UPDATE characters_accounts SET `transactions` = '" .. json.encode(NewTransactionData) .. "' WHERE `bankid` = '" ..BankId.. "'")
        end
    end)
end)

RegisterServerEvent('fw-banking:server:remove:account')
AddEventHandler('fw-banking:server:remove:account', function(BankId)
    Framework.Functions.ExecuteSql(false, 'DELETE FROM `characters_accounts` WHERE `bankid` = "'..BankId..'"')
end)

RegisterNetEvent('fw-banking:server:give:cash')
AddEventHandler('fw-banking:server:give:cash', function(TargetPlayer, Amount)
    local SelfPlayer = Framework.Functions.GetPlayer(source)
    local TargetPlayer = Framework.Functions.GetPlayer(TargetPlayer)
    SelfPlayer.Functions.RemoveMoney('cash', Amount, 'Contant Geven')
    TargetPlayer.Functions.AddMoney('cash', Amount, 'Contant Geven')
    TriggerClientEvent('Framework:Notify', SelfPlayer.PlayerData.source, "Je hebt €"..Amount.. " gegeven", "success", 4500)
    TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, "Je ontving €"..Amount.. " van "..SelfPlayer.PlayerData.charinfo.firstname, "success", 4500)
end)

Framework.Commands.Add("geefcontant", "Geef contant geld aan een persoon", {{name="id", help="Speler ID"},{name="bedrag", help="Hoeveel geld"}}, true, function(source, args)
    local SelfPlayer = Framework.Functions.GetPlayer(source)
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    local Amount = tonumber(args[2])
    if TargetPlayer ~= nil then
        if TargetPlayer.PlayerData.source ~= SelfPlayer.PlayerData.source then
            if Amount ~= nil and Amount > 0 then
                if SelfPlayer.PlayerData.money['cash'] >= Amount then
                    TriggerClientEvent('fw-banking:client:check:players:near', SelfPlayer.PlayerData.source, TargetPlayer.PlayerData.source, Amount)
                else
                    TriggerClientEvent('Framework:Notify', source, "Je hebt niet genoeg contant..", "error", 4500)
                end
            end
        else
            TriggerClientEvent('Framework:Notify', source, "Hoe dan?", "error", 4500)
        end
    else
        TriggerClientEvent('Framework:Notify', source, "Geen burger gevonden..", "error", 4500)
    end
end)

function GetCharName(CitizenId)
    local CharName = nil
    Framework.Functions.ExecuteSql(true, "SELECT * FROM characters_metadata WHERE `citizenid` = '"..CitizenId.."'", function(CharResult) 
        local DecodeCharInfo = json.decode(CharResult[1].charinfo)
        CharName = DecodeCharInfo.firstname..' '..DecodeCharInfo.lastname
    end)
    return CharName
end

function GetAccountBalance(BankId)
    local ReturnData = nil
    Framework.Functions.ExecuteSql(true, "SELECT * FROM characters_accounts WHERE `bankid` = '"..BankId.."'", function(result)
        ReturnData = result[1].balance
    end)
    return ReturnData
end

function CreateRandomIban()
    return "NL0"..math.random(1,9)..Framework.Shared.RandomInt(3):upper()..math.random(1111,9999)..math.random(1111,9999)..math.random(11,99)
end