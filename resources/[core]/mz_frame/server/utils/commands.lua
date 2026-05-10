MZ = MZ or {}

MZ.RegisterCommand = function(name, roles, cb)
    RegisterCommand(name, function(source, args, rawCommand)
        if source == 0 then
            cb(source, args, rawCommand)
            return
        end

        if roles and #roles > 0 then
            local player = MZ.GetPlayer(source)
            if not player or not table.contains(roles, player.role) then
                TriggerClientEvent('mz_frame:notification', source, 'You do not have permission to use this command.')
                return
            end
        end

        cb(source, args, rawCommand)
    end, false)
end

