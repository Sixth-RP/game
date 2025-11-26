# Police Speed Radar - QBCore

A realistic police speed radar system for QBCore FiveM servers with a professional UI displaying front and rear radar speeds, license plates, and patrol speed.

## Features

- 🚔 Front and rear vehicle speed detection
- 📋 Automatic license plate reading
- 🔒 Speed locking capability for both front and rear radar
- 🎨 Professional digital display interface
- ⚙️ Configurable speed units (MPH/KMH)
- 👮 Job-restricted access (police, sheriff, statepolice)
- 🚨 Emergency vehicle requirement

## Installation

1. Copy the `police-radar` folder to your server's `resources` directory
2. Add `ensure police-radar` to your `server.cfg`
3. Restart your server

## Configuration

Edit `config.lua` to customize:

```lua
Config.ToggleKey = 'F5'           -- Key to toggle radar
Config.SpeedUnit = 'mph'          -- Speed unit: 'mph' or 'kmh'
Config.RadarRange = 150.0         -- Detection range in meters
Config.UpdateInterval = 100       -- Update frequency in milliseconds
Config.AllowedJobs = {            -- Jobs that can use radar
    'police',
    'sheriff',
    'statepolice'
}
```

## Usage

### Commands

- `/radar` or `F5` - Toggle the radar display on/off
- `/radarfront` - Lock/unlock front radar speed
- `/radarrear` - Lock/unlock rear radar speed

### How to Use

1. Get into an emergency vehicle (police car, sheriff vehicle, etc.)
2. Press `F5` or type `/radar` to activate the radar
3. The display shows:
   - **Front Speed**: Vehicle ahead of you
   - **Rear Speed**: Vehicle behind you
   - **Patrol Speed**: Your current speed
   - **License Plates**: Automatically captured for detected vehicles
4. Use `/radarfront` to lock the front radar reading (turns red when locked)
5. Use `/radarrear` to lock the rear radar reading (turns red when locked)
6. The radar automatically turns off when you exit the vehicle

## Features Explained

### Speed Detection
- Real-time speed monitoring for vehicles in front and behind
- Automatic speed unit conversion (MPH/KMH)
- Visual feedback with digital-style displays

### License Plate Reading
- Automatically captures and displays license plates
- Plates remain visible when speeds are locked

### Speed Locking
- Lock speeds to preserve evidence
- Locked speeds display in red
- Independent locking for front and rear radar

### Permissions
- Restricted to configured police jobs
- Must be in an emergency vehicle class
- Server-side permission validation

## Requirements

- QBCore Framework
- FiveM Server

## Credits

Created for QBCore FiveM servers