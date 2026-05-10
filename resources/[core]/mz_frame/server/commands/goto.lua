-- Allowed roles: mod, admin, superadmin
MZ.RegisterCommand('goto', { 'mod', 'admin', 'superadmin' }, function(source, args)
    local targetId = tonumber(args[1])
    if not targetId then return end

    for src, player in pairs(MZ.GetPlayers()) do
        if player.ingame_id == targetId then
            local coords = GetEntityCoords(GetPlayerPed(src))
            TriggerClientEvent('mz_frame:teleportTo', source, coords.x, coords.y, coords.z)
            return
        end
    end
end)
