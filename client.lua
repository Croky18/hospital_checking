local Framework = nil

Citizen.CreateThread(function()
    if Config.Framework == 'qbcore' then
        Framework = exports['qb-core']:GetCoreObject()
    end
end)

local doctorNPC = nil


function SpawnDoctorNPC()
    local model = GetHashKey(Config.DoctorModel)

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end

    doctorNPC = CreatePed(4, model, Config.DoctorCoords.x, Config.DoctorCoords.y, Config.DoctorCoords.z - 1, Config.DoctorHeading, false, true)
    SetEntityInvincible(doctorNPC, true)
    FreezeEntityPosition(doctorNPC, true)
    SetBlockingOfNonTemporaryEvents(doctorNPC, true)
end



Citizen.CreateThread(function()
    Wait(2000)
    SpawnDoctorNPC()
end)


Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())

        if #(playerCoords - Config.DoctorCoords) < 2.0 then
            if Config.Framework == 'esx' then
                ESX.ShowHelpNotification("Druk op ~INPUT_CONTEXT~ voor een medische check-up ($" .. Config.CheckupPrice .. ")")
            elseif Config.Framework == 'qbcore' then
                Framework.Functions.DrawText3D(Config.DoctorCoords.x, Config.DoctorCoords.y, Config.DoctorCoords.z + 1.0, "[E] Medische check-up ($" .. Config.CheckupPrice .. ")")
            end

            if IsControlJustReleased(0, 38) then
                TriggerServerEvent('hospital:checkup')
            end
        end
    end
end)

RegisterNetEvent('hospital:healPlayer')
AddEventHandler('hospital:healPlayer', function()
    local playerPed = PlayerPedId()
    

    SetEntityHealth(playerPed, 200)

    -- Eventueel dood-status opheffen
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
    

    if Config.Framework == 'esx' then
        ESX.ShowNotification('Je bent volledig genezen door de dokter!')
    elseif Config.Framework == 'qbcore' then
        Framework.Functions.Notify('Je bent volledig genezen door de dokter!', 'success')
    end
end)
