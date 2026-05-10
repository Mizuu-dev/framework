MZ = MZ or {}

local LocalPlayer = {}

MZ.GetPlayerData = function()
    return LocalPlayer
end

AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    MZ.TriggerCallback('mz_frame:getPlayerData', function(data)
        if data then LocalPlayer = data end
    end)
end)

RegisterNetEvent('mz_frame:teleportTo')
AddEventHandler('mz_frame:teleportTo', function(x, y, z)
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false)
end)
