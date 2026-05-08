AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    local ok, err = pcall(addSpawnPoint, {
        x = 0.0,
        y = 0.0,
        z = 72.0,
        heading = 0.0,
        model = 'mp_m_freemode_01',
    })

    if not ok then
        Citizen.Trace('^1[gamemode] addSpawnPoint failed: ' .. tostring(err) .. '\n')
    end

    setAutoSpawn(false)

    Citizen.CreateThread(function()
        while not NetworkIsPlayerActive(PlayerId()) do
            Citizen.Wait(100)
        end

        spawnPlayer()
    end)
end)

AddEventHandler('playerSpawned', function()
    local ped = PlayerPedId()
    SetEntityVisible(ped, true)
    SetEntityCollision(ped, true)
    FreezeEntityPosition(ped, false)
    SetPlayerInvincible(PlayerId(), false)
    SetPlayerControl(PlayerId(), true, false)
end)