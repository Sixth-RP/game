local QBCore = exports['qb-core']:GetCoreObject()
local radarActive = false
local radarVisible = false
local frontPlate = nil
local rearPlate = nil
local lockedFrontSpeed = nil
local lockedRearSpeed = nil

-- Helper function to get vehicle in front
local function GetVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
    local _, hit, _, _, vehicle = GetShapeTestResult(rayHandle)
    
    if hit and DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        return vehicle
    end
    
    return nil
end

-- Helper function to get vehicle behind
local function GetVehicleBehind()
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    local coordA = GetOffsetFromEntityInWorldCoords(playerVeh, 0.0, -10.0, 0.0)
    local coordB = GetOffsetFromEntityInWorldCoords(playerVeh, 0.0, -150.0, 0.0)
    
    return GetVehicleInDirection(coordA, coordB)
end

-- Helper function to get vehicle in front
local function GetVehicleInFront()
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    local coordA = GetOffsetFromEntityInWorldCoords(playerVeh, 0.0, 10.0, 0.0)
    local coordB = GetOffsetFromEntityInWorldCoords(playerVeh, 0.0, 150.0, 0.0)
    
    return GetVehicleInDirection(coordA, coordB)
end

-- Convert speed to configured unit
local function ConvertSpeed(speed)
    if Config.SpeedUnit == 'mph' then
        return math.floor(speed * 2.236936)
    else
        return math.floor(speed * 3.6)
    end
end

-- Get license plate from vehicle
local function GetPlate(vehicle)
    if DoesEntityExist(vehicle) then
        return GetVehicleNumberPlateText(vehicle)
    end
    return nil
end

-- Main radar loop
CreateThread(function()
    while true do
        Wait(Config.UpdateInterval)
        
        if radarActive then
            local playerPed = PlayerPedId()
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
            
            if playerVeh ~= 0 then
                local patrolSpeed = ConvertSpeed(GetEntitySpeed(playerVeh))
                
                -- Front radar
                local frontVehicle = GetVehicleInFront()
                local frontSpeed = 0
                local frontPlateText = ''
                
                if frontVehicle ~= nil and lockedFrontSpeed == nil then
                    frontSpeed = ConvertSpeed(GetEntitySpeed(frontVehicle))
                    frontPlateText = GetPlate(frontVehicle)
                    frontPlate = frontPlateText
                elseif lockedFrontSpeed ~= nil then
                    frontSpeed = lockedFrontSpeed
                    frontPlateText = frontPlate or ''
                end
                
                -- Rear radar
                local rearVehicle = GetVehicleBehind()
                local rearSpeed = 0
                local rearPlateText = ''
                
                if rearVehicle ~= nil and lockedRearSpeed == nil then
                    rearSpeed = ConvertSpeed(GetEntitySpeed(rearVehicle))
                    rearPlateText = GetPlate(rearVehicle)
                    rearPlate = rearPlateText
                elseif lockedRearSpeed ~= nil then
                    rearSpeed = lockedRearSpeed
                    rearPlateText = rearPlate or ''
                end
                
                -- Send data to UI
                SendNUIMessage({
                    action = 'updateRadar',
                    patrolSpeed = patrolSpeed,
                    frontSpeed = frontSpeed,
                    rearSpeed = rearSpeed,
                    frontPlate = frontPlateText,
                    rearPlate = rearPlateText,
                    speedUnit = Config.SpeedUnit:upper(),
                    frontLocked = lockedFrontSpeed ~= nil,
                    rearLocked = lockedRearSpeed ~= nil
                })
            end
        end
    end
end)

-- Toggle radar display
local function ToggleRadar()
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    
    if playerVeh ~= 0 then
        local vehicleClass = GetVehicleClass(playerVeh)
        local canUse = false
        
        for _, allowedClass in ipairs(Config.AllowedVehicleClasses) do
            if vehicleClass == allowedClass then
                canUse = true
                break
            end
        end
        
        if canUse then
            TriggerServerEvent('police-radar:server:checkPermission')
        else
            QBCore.Functions.Notify('You must be in a patrol vehicle', 'error')
        end
    else
        QBCore.Functions.Notify('You must be in a vehicle', 'error')
    end
end

-- Lock/unlock front speed
RegisterCommand('radarfront', function()
    if radarActive then
        if lockedFrontSpeed == nil then
            local frontVehicle = GetVehicleInFront()
            if frontVehicle ~= nil then
                lockedFrontSpeed = ConvertSpeed(GetEntitySpeed(frontVehicle))
                frontPlate = GetPlate(frontVehicle)
                QBCore.Functions.Notify('Front radar locked', 'success')
            end
        else
            lockedFrontSpeed = nil
            frontPlate = nil
            QBCore.Functions.Notify('Front radar unlocked', 'success')
        end
    end
end)

-- Lock/unlock rear speed
RegisterCommand('radarrear', function()
    if radarActive then
        if lockedRearSpeed == nil then
            local rearVehicle = GetVehicleBehind()
            if rearVehicle ~= nil then
                lockedRearSpeed = ConvertSpeed(GetEntitySpeed(rearVehicle))
                rearPlate = GetPlate(rearVehicle)
                QBCore.Functions.Notify('Rear radar locked', 'success')
            end
        else
            lockedRearSpeed = nil
            rearPlate = nil
            QBCore.Functions.Notify('Rear radar unlocked', 'success')
        end
    end
end)

-- Toggle radar command
RegisterCommand('radar', function()
    ToggleRadar()
end)

-- Keybind
RegisterKeyMapping('radar', 'Toggle Police Radar', 'keyboard', Config.ToggleKey)

-- Permission result from server
RegisterNetEvent('police-radar:client:permissionResult', function(hasPermission)
    if hasPermission then
        radarActive = not radarActive
        radarVisible = radarActive
        
        if radarActive then
            QBCore.Functions.Notify('Radar activated', 'success')
            lockedFrontSpeed = nil
            lockedRearSpeed = nil
            frontPlate = nil
            rearPlate = nil
        else
            QBCore.Functions.Notify('Radar deactivated', 'error')
        end
        
        SendNUIMessage({
            action = 'toggleRadar',
            show = radarVisible
        })
    else
        QBCore.Functions.Notify('You don\'t have permission to use the radar', 'error')
    end
end)

-- Hide radar when exiting vehicle
CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        local playerVeh = GetVehiclePedIsIn(playerPed, false)
        
        if radarActive and playerVeh == 0 then
            radarActive = false
            radarVisible = false
            lockedFrontSpeed = nil
            lockedRearSpeed = nil
            frontPlate = nil
            rearPlate = nil
            
            SendNUIMessage({
                action = 'toggleRadar',
                show = false
            })
        end
    end
end)
