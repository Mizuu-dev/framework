AddEventHandler('playerConnecting', function(_, _, deferrals)
    local src = source
    deferrals.defer()

    local identifier
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:sub(1, 8) == 'license:' then
            identifier = id
            break
        end
    end

    if not identifier then
        deferrals.done('Could not verify your identity.')
        return
    end

    DB.Fetch('SELECT id FROM bans WHERE identifier = ?', { identifier }, function(rows)
        if rows and #rows > 0 then
            deferrals.done('You are banned from this server.')
        else
            deferrals.done()
        end
    end)
end)

-- Allowed roles: admin, superadmin
MZ.RegisterCommand('ban', { 'admin', 'superadmin' }, function(source, args)
    local targetId = tonumber(args[1])
    if not targetId then return end

    local reason = #args > 1 and table.concat(args, ' ', 2) or 'No reason given'
    local admin  = MZ.GetPlayer(source)

    for src, player in pairs(MZ.GetPlayers()) do
        if player.ingame_id == targetId then
            DB.Execute(
                'INSERT INTO bans (identifier, reason, banned_by) VALUES (?, ?, ?)',
                { player.identifier, reason, admin.ingame_id }
            )
            DropPlayer(src, 'You have been banned: ' .. reason)
            return
        end
    end
end)
