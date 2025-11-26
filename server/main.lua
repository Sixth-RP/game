local QBCore = exports['qb-core']:GetCoreObject()

-- Server event to check if player has permission to use radar
RegisterNetEvent('police-radar:server:checkPermission', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        local hasPermission = false
        
        for _, job in ipairs(Config.AllowedJobs) do
            if Player.PlayerData.job.name == job then
                hasPermission = true
                break
            end
        end
        
        TriggerClientEvent('police-radar:client:permissionResult', src, hasPermission)
    else
        TriggerClientEvent('police-radar:client:permissionResult', src, false)
    end
end)
