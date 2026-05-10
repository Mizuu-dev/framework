-- Allowed roles: mod, admin, superadmin
MZ.RegisterCommand('bring', { 'mod', 'admin', 'superadmin' }, function(source, args)
    local targetId = tonumber(args[1])
    if not targetId then return end

    local coords = GetEntityCoords(GetPlayerPed(source))

    for src, player in pairs(MZ.GetPlayers()) do
        if player.ingame_id == targetId then
            TriggerClientEvent('mz_frame:teleportTo', src, coords.x, coords.y, coords.z)
            return
        end
    end
end)
