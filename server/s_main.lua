ESX = exports['es_extended']:getSharedObject()

lib.locale()

Notify = function(msg, type)
    lib.notify(source, {
        description = msg,
        type = type
    })
end

ESX.RegisterUsableItem(Config.DigItem, function(source)
    lib.callback.await('esx_digarea:StartDig', source)
end)

ESX.RegisterUsableItem(Config.PanItem, function(source)
    lib.callback.await('esx_digarea:StartPan', source)
end)


lib.callback.register('esx_digarea:CheckItem', function(source)
    local ped = ESX.GetPlayerFromId(source)

    if ped.getInventoryItem(Config.SandItem).count > Config.PanItemAmount - 1 then
        return true
    else
        return false
    end
end)

lib.callback.register('esx_digarea:PanReward', function(source)
    local mahdollisuus = math.random(1, 100)
    local items = Config.Items[math.random(#Config.Items)]
    local amount = math.random(1, 2)

    if mahdollisuus <= Config.ChanceForNothing then
        exports.ox_inventory:RemoveItem(source, Config.SandItem, Config.PanItemAmount)
        exports.ox_inventory:AddItem(source, items, amount)
    else
        exports.ox_inventory:RemoveItem(source, Config.SandItem, Config.PanItemAmount)
        Notify(locale('you_got_nothing'), 'error')
    end
end)

lib.callback.register('esx_digarea:GetReward', function(source)
    local ped = ESX.GetPlayerFromId(source)
    local mahdollisuus = math.random(1, 100)
    local amount = math.random(Config.Min, Config.Max)

    if mahdollisuus <= Config.Chance then
        exports.ox_inventory:AddItem(source, Config.GoldItem, Config.GoldAmount)
        exports.ox_inventory:AddItem(source, Config.SandItem, amount)
        Notify(locale('get_premium_reward')..amount..locale('get_premium_reward2'), 'success')
        LOG(locale('log_premium_reward')..amount..locale('log_premium_reward2')..'\n Player: '..GetPlayerName(source)..'\n Hex ID: '..GetPlayerIdentifier(source))
    else
        exports.ox_inventory:AddItem(source, Config.SandItem, amount)
        Notify(locale('get_normal_reward')..amount..locale('get_normal_reward2'), 'success')
        LOG(locale('log_normal_reward')..amount..locale('log_normal_reward2')..'\n Player: '..GetPlayerName(source)..'\n Hex ID: '..GetPlayerIdentifier(source))
    end
end)

function LOG(message, color)
    local logs = '' or Config.Webhook
    local connect = {  {  ["description"] = message, ["color"] = color, ["footer"] = { ["text"] = os.date("\n📅 %d.%m.%Y \n⏰ %X"), }, } }
    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = 'Taala-Scripts', embeds = connect}), { ['Content-Type'] = 'application/json' })
end
