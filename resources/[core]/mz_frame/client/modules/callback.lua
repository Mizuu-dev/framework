MZ = MZ or {}

local pending = {}
local counter = 0

MZ.TriggerCallback = function(name, cb, ...)
    counter = counter + 1
    local id = counter
    pending[id] = cb
    TriggerServerEvent('mz_frame:serverCallback', name, id, ...)
end

RegisterNetEvent('mz_frame:clientCallback')
AddEventHandler('mz_frame:clientCallback', function(requestId, result)
    local cb = pending[requestId]
    if cb then
        pending[requestId] = nil
        cb(result)
    end
end)
