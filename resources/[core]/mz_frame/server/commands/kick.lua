-- Allowed roles: admin, superadmin
MZ.RegisterCommand('kick', { 'admin', 'superadmin' }, function(source, args)
    local targetId = tonumber(args[1])
    local reason   = args[2] or 'No reason given'
    if not targetId then return end

    for src, player in pairs(MZ.GetPlayers()) do
        if player.ingame_id == targetId then
            DropPlayer(src, reason)
            return
        end
    end
end)
