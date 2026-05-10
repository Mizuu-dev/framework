Identity = {}

function Identity.getLicense(source)
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(id, 1, 8) == 'license:' then
            return id
        end
    end
    return nil
end

function Identity.applyId(source, player)
    local ingame_id = tonumber(player and player.ingame_id)
    if not ingame_id then return end

    local state = Player(source).state
    state:set('ingame_id', ingame_id, true)
    state:set('permanent_id', ingame_id, true)
    state:set('txadmin_id', ingame_id, true)

    if Config.DebugLog then
        print(string.format(
            '[id_bridge] src %d -> ingame_id #%d (%s)',
            source, ingame_id, GetPlayerName(source) or 'unknown'
        ))
    end
end

local function normalizePlayer(row)
    if not row then return nil end
    return {
        db_id = tonumber(row.id),
        ingame_id = tonumber(row.ingame_id),
    }
end

local function createMissingPlayer(source, license, attemptsLeft, done)
    if not Config.CreateMissingPlayers then
        done(nil)
        return
    end

    DB.fetchNextIngameId(function(nextId)
        nextId = tonumber(nextId) or 1

        DB.insertPlayer(license, nextId, function(insertId)
            DB.fetchPlayer(license, function(row)
                local player = normalizePlayer(row)
                if player then
                    done(player)
                    return
                end

                if attemptsLeft > 0 then
                    createMissingPlayer(source, license, attemptsLeft - 1, done)
                else
                    done(nil)
                end
            end)
        end)
    end)
end

function Identity.resolve(source, license, done)
    done = done or function() end

    local cached = Cache.get(license)
    if cached then
        Identity.applyId(source, cached)
        DB.touchPlayer(license)
        done(cached)
        return
    end

    DB.fetchPlayer(license, function(row)
        local player = normalizePlayer(row)
        if player then
            Cache.set(license, player)
            Identity.applyId(source, player)
            DB.touchPlayer(license)
            done(player)
            return
        end

        createMissingPlayer(source, license, Config.InsertRetries, function(created)
            if created then
                Cache.set(license, created)
                Identity.applyId(source, created)
                done(created)
                return
            end

            if Config.DebugLog then
                print(string.format(
                    '[id_bridge] failed to resolve/create permanent id for src %d',
                    source
                ))
            end
            done(nil)
        end)
    end)
end

function Identity.resolveSourceByIngameId(ingame_id)
    local wanted = tonumber(ingame_id)
    if not wanted then return nil end

    for _, playerSource in ipairs(GetPlayers()) do
        local source = tonumber(playerSource)
        local current = tonumber(Player(source).state.ingame_id)
        if current == wanted then
            return source
        end
    end

    return nil
end
