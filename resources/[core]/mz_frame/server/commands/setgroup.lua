-- Allowed roles: superadmin, console
MZ.RegisterCommand('setgroup', { 'superadmin' }, function(source, args)
    local targetId = tonumber(args[1])
    local newRole  = args[2]

    if not targetId or not newRole then return end

    if not table.contains(MZ.Config.Roles, newRole) then
        if source ~= 0 then
            TriggerClientEvent('mz_frame:notification', source, 'Invalid role. Valid roles: ' .. table.concat(MZ.Config.Roles, ', '))
        end
        return
    end

    for src, player in pairs(MZ.GetPlayers()) do
        if player.ingame_id == targetId then
            player.role = newRole
            DB.Execute('UPDATE players SET role = ? WHERE id = ?', { newRole, player.id })
            return
        end
    end
end)
