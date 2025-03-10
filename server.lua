local Framework = nil

Citizen.CreateThread(function()
    Wait(1000)

    if Config.Framework == 'esx' then
        Framework = exports['es_extended']:getSharedObject() -- ESX correct ophalen
        print("[INFO] ESX Framework geladen!")
    elseif Config.Framework == 'qbcore' then
        Framework = exports['qb-core']:GetCoreObject()
        print("[INFO] QBCore Framework geladen!")
    end
end)

RegisterNetEvent('hospital:checkup')
AddEventHandler('hospital:checkup', function()
    local src = source
    local price = Config.CheckupPrice

    if Config.Framework == 'esx' then
        local xPlayer = Framework.GetPlayerFromId(src) -- Gebruik de correcte manier
        if xPlayer and xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price)
            TriggerClientEvent('esx:showNotification', src, 'Je hebt een medische check-up gehad. Kosten: $' .. price)
            TriggerClientEvent('hospital:healPlayer', src) -- Speler healen
        else
            TriggerClientEvent('esx:showNotification', src, 'Je hebt niet genoeg geld voor een check-up!')
        end

    elseif Config.Framework == 'qbcore' then
        local Player = Framework.Functions.GetPlayer(src)
        if Player and Player.Functions.RemoveMoney('cash', price) then
            TriggerClientEvent('QBCore:Notify', src, 'Je hebt een medische check-up gehad. Kosten: $' .. price, 'success')
            TriggerClientEvent('hospital:healPlayer', src) -- Speler healen
        else
            TriggerClientEvent('QBCore:Notify', src, 'Je hebt niet genoeg geld voor een check-up!', 'error')
        end
    end
end)
