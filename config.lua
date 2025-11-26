Config = {}

-- Keybind to toggle radar
Config.ToggleKey = 'F5'

-- Speed unit (mph or kmh)
Config.SpeedUnit = 'mph'

-- Maximum radar range in meters
Config.RadarRange = 150.0

-- Update interval in milliseconds
Config.UpdateInterval = 100

-- Allowed job to use radar
Config.AllowedJobs = {
    'police',
    'sheriff',
    'statepolice'
}

-- Patrol vehicle classes that can use radar
Config.AllowedVehicleClasses = {
    18 -- Emergency vehicles
}
