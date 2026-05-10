local spawnPoints     = {}
local spawnNum        = 1
local autoSpawnEnabled = false
local autoSpawnCallback
local spawnLock       = false
local diedAt
local respawnForced

AddEventHandler('getMapDirectives', function(add)
    add('spawnpoint', function(state, model)
        return function(opts)
            local x = opts.x or opts[1]
            local y = opts.y or opts[2]
            local z = opts.z or opts[3]
            if not x or not y or not z then return end

            local heading = opts.heading and (opts.heading + 0.01) or 0.0
            addSpawnPoint({ x = x + 0.0001, y = y + 0.0001, z = z + 0.0001, heading = heading, model = model })

            if not tonumber(model) then model = GetHashKey(model) end
            state.add('xyz',   { x, y, z })
            state.add('model', model)
        end
    end, function(state)
        for i, sp in ipairs(spawnPoints) do
            if sp.x == state.xyz[1] and sp.y == state.xyz[2] and sp.z == state.xyz[3] and sp.model == state.model then
                table.remove(spawnPoints, i)
                return
            end
        end
    end)
end)

function loadSpawns(spawnString)
    local data = json.decode(spawnString)
    if not data.spawns then error("no 'spawns' in JSON data") end
    for _, spawn in ipairs(data.spawns) do addSpawnPoint(spawn) end
end

function addSpawnPoint(spawn)
    if not tonumber(spawn.x) or not tonumber(spawn.y) or not tonumber(spawn.z) then
        error('invalid spawn position')
    end
    if not tonumber(spawn.heading) then error('invalid spawn heading') end

    local model = spawn.model
    if model and not tonumber(model) then model = GetHashKey(model) end
    if model and not IsModelInCdimage(model) then
        Citizen.Trace('^3[spawnmanager] IsModelInCdimage false for ' .. tostring(model) .. '\n')
    end

    spawn.model = model
    spawn.idx   = spawnNum
    spawnNum    = spawnNum + 1
    table.insert(spawnPoints, spawn)
    return spawn.idx
end

function removeSpawnPoint(idx)
    for i = 1, #spawnPoints do
        if spawnPoints[i].idx == idx then
            table.remove(spawnPoints, i)
            return
        end
    end
end

function setAutoSpawn(enabled)
    autoSpawnEnabled = enabled
end

function setAutoSpawnCallback(cb)
    autoSpawnCallback = cb
    autoSpawnEnabled  = true
end

local function freezePlayer(freeze)
    local pid = PlayerId()
    local ped = PlayerPedId()
    SetPlayerControl(pid, not freeze, false)
    if freeze then
        SetEntityVisible(ped, false)
        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(pid, true)
        if not IsPedFatallyInjured(ped) then ClearPedTasksImmediately(ped) end
    else
        SetEntityVisible(ped, true)
        if not IsPedInAnyVehicle(ped) then SetEntityCollision(ped, true) end
        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(pid, false)
    end
end

function spawnPlayer(spawnIdx, cb)
    if spawnLock then return end
    spawnLock = true

    Citizen.CreateThread(function()
        local spawn
        if type(spawnIdx) == 'table' then
            spawn         = spawnIdx
            spawn.x       = spawn.x + 0.0
            spawn.y       = spawn.y + 0.0
            spawn.z       = spawn.z + 0.0
            spawn.heading = spawn.heading and (spawn.heading + 0.0) or 0.0
        else
            local idx = spawnIdx or GetRandomIntInRange(1, #spawnPoints + 1)
            spawn = spawnPoints[idx]
        end

        if not spawn then
            Citizen.Trace('[spawnmanager] invalid spawn\n')
            spawnLock = false
            return
        end

        if not spawn.skipFade then
            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do Citizen.Wait(0) end
        end

        freezePlayer(true)

        if spawn.model then
            RequestModel(spawn.model)
            while not HasModelLoaded(spawn.model) do
                RequestModel(spawn.model)
                Wait(0)
            end
            SetPlayerModel(PlayerId(), spawn.model)
            SetPedDefaultComponentVariation(PlayerPedId())
            SetModelAsNoLongerNeeded(spawn.model)
        end

        RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)

        local ped = PlayerPedId()
        SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false, true)
        NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, true, false)
        ClearPedTasksImmediately(ped)
        RemoveAllPedWeapons(ped)
        ClearPlayerWantedLevel(PlayerId())

        local timer = GetGameTimer()
        while not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - timer) < 5000 do
            Citizen.Wait(0)
        end

        ShutdownLoadingScreen()

        if IsScreenFadedOut() then
            DoScreenFadeIn(500)
            while not IsScreenFadedIn() do Citizen.Wait(0) end
        end

        freezePlayer(false)
        TriggerEvent('playerSpawned', spawn)
        if cb then cb(spawn) end
        spawnLock = false
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        local ped = PlayerPedId()
        if ped and ped ~= -1 then
            if autoSpawnEnabled and NetworkIsPlayerActive(PlayerId()) then
                if respawnForced or (diedAt and math.abs(GetTimeDifference(GetGameTimer(), diedAt)) > 2000) then
                    if autoSpawnCallback then autoSpawnCallback() else spawnPlayer() end
                    respawnForced = false
                    diedAt        = nil
                end
            end
            if IsEntityDead(ped) then
                if not diedAt then diedAt = GetGameTimer() end
            else
                if not autoSpawnEnabled then diedAt = nil end
            end
        end
    end
end)

function forceRespawn()
    spawnLock     = false
    respawnForced = true
end

exports('spawnPlayer',          spawnPlayer)
exports('addSpawnPoint',        addSpawnPoint)
exports('removeSpawnPoint',     removeSpawnPoint)
exports('loadSpawns',           loadSpawns)
exports('setAutoSpawn',         setAutoSpawn)
exports('setAutoSpawnCallback', setAutoSpawnCallback)
exports('forceRespawn',         forceRespawn)
