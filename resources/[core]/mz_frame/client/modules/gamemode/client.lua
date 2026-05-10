AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    setAutoSpawn(false)

    Citizen.CreateThread(function()
        while not NetworkIsPlayerActive(PlayerId()) do
            Citizen.Wait(100)
        end

        MZ.TriggerCallback('mz_frame:getPlayerData', function(data)
            local x, y, z = 0.0, 0.0, 72.0

            if data and data.last_location then
                local loc = json.decode(data.last_location)
                if loc and loc.x then
                    x, y, z = loc.x, loc.y, loc.z
                end
            end

            spawnPlayer({ x = x, y = y, z = z, heading = 0.0, model = 'mp_m_freemode_01' })
        end)
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