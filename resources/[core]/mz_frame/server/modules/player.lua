MZ = MZ or {}

local function getLicense(src)
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:sub(1, 8) == 'license:' then
            return id
        end
    end
end

local function applyPermanentId(src, ingameId)
    ingameId = tonumber(ingameId)
    if not ingameId then return end

    local state = Player(src).state
    state:set('ingame_id', ingameId, true)
    state:set('permanent_id', ingameId, true)
    state:set('txadmin_id', ingameId, true)
end

AddEventHandler('playerJoining', function()
    local src = source
    local identifier = getLicense(src)
    if not identifier then return end

    DB.Fetch('SELECT id, ingame_id, first_name, last_name, role, last_location FROM players WHERE identifier = ?', { identifier }, function(rows)
        if rows and #rows > 0 then
            local row = rows[1]
            MZ.AddPlayer(src, {
                source        = src,
                identifier    = identifier,
                id            = row.id,
                ingame_id     = row.ingame_id,
                first_name    = row.first_name,
                last_name     = row.last_name,
                role          = row.role or 'user',
                last_location = row.last_location,
            })
            applyPermanentId(src, row.ingame_id)
            print('Connecting: ' .. GetPlayerName(src) .. '^7 - ID: ' .. row.ingame_id)
        else
            DB.Fetch('SELECT MAX(ingame_id) AS max_id FROM players', {}, function(result)
                local nextId          = 1
                local defaultLocation = '{"x":0.0,"y":0.0,"z":72.0}'
                if result and result[1] and result[1].max_id then
                    nextId = result[1].max_id + 1
                end

                DB.Insert(
                    'INSERT INTO players (identifier, first_name, last_name, ingame_id, last_location, sex) VALUES (?, ?, ?, ?, ?, ?)',
                    { identifier, 'Unset', 'Unset', nextId, defaultLocation, 'male' },
                    function(id)
                        MZ.AddPlayer(src, {
                            source        = src,
                            identifier    = identifier,
                            id            = id,
                            ingame_id     = nextId,
                            first_name    = 'Unset',
                            last_name     = 'Unset',
                            role          = 'user',
                            last_location = defaultLocation,
                        })
                        applyPermanentId(src, nextId)
                        print('Connecting: ' .. GetPlayerName(src) .. '^7 - ID: ' .. nextId .. ' (new)')
                    end
                )
            end)
        end
    end)
end)

AddEventHandler('playerDropped', function()
    local src    = source
    local player = MZ.GetPlayer(src)
    if player then
        local ped = GetPlayerPed(src)
        if ped and ped ~= 0 then
            local coords = GetEntityCoords(ped)
            DB.Execute(
                'UPDATE players SET last_location = ? WHERE id = ?',
                { ('{"x":%.4f,"y":%.4f,"z":%.4f}'):format(coords.x, coords.y, coords.z), player.id }
            )
        end
    end
    MZ.RemovePlayer(src)
end)

MZ.RegisterCallback('mz_frame:getPlayerData', function(src, cb)
    cb(MZ.GetPlayer(src))
end)
