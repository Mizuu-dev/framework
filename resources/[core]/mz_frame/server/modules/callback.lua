MZ = MZ or {}
MZ.Callbacks = {}

MZ.RegisterCallback = function(name, cb)
    MZ.Callbacks[name] = cb
end

RegisterNetEvent('mz_frame:serverCallback')
AddEventHandler('mz_frame:serverCallback', function(name, requestId, ...)
    local cb = MZ.Callbacks[name]
    if not cb then return end
    local src = source
    cb(src, function(result)
        TriggerClientEvent('mz_frame:clientCallback', src, requestId, result)
    end, ...)
end)
