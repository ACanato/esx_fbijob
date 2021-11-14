Config                        = {}
Config.DrawDistance           = 100.0
Config.MarkerType             = 1
Config.MarkerSize             = {x = 1.5, y = 1.5, z = 1.0}
Config.MarkerColor            = {r = 50, g = 50, b = 204}
Config.EnablePlayerManagement = true
Config.EnableArmoryManagement = true
Config.MaxInService           = -1
Config.Locale       		  = 'en'

Config.fbiStations = {
	
	LSPD = {

		Blip = {
			Pos   = {x = 425.130, y = -979.558, z = 30.711},
			Color = 29
		},

		AuthorizedWeapons = {
			{name = 'weapon_flashlight',     price = 0},
			{name = 'weapon_hatchet',     	 price = 0},
			{name = 'weapon_combatpistol',   price = 0},
			{name = 'weapon_smg',     		 price = 0},
			{name = 'weapon_assaultsmg',     price = 0},
			{name = 'weapon_pumpshotgun',    price = 0},
			{name = 'weapon_carbinerifle',   price = 0},
			{name = 'weapon_sniperrifle',    price = 0},
			{name = 'weapon_grenade',     	 price = 0},
			{name = 'weapon_bzgas',     	 price = 0},
			{name = 'weapon_stickybomb',     price = 0},
			{name = 'weapon_smokegrenade',   price = 0},
		},

		AuthorizedVehicles = {
			{name = 'fbi',		 	label = 'FBI Car'},
			{name = 'fbi2',			label = 'FBI Van'}
		},

		Cloakrooms = {
			{x = 462.0, y = -999.07, z = 29.69}
		},

		Armories = {
			{x = 482.62, y = -995.99, z = 29.69}
		},

		Vehicles = {
			{
				Spawner    = {x = 457.05, y = -1017.3, z = 27.35},
				SpawnPoint = {x = 438.42, y = -1018.3, z = 27.757},
				Heading    = 90.0
			}
		},

		Helicopters = {
			{
				Spawner    = {x = 462.342, y = -988.694, z = 43.686},
				SpawnPoint = {x = 449.156, y = -981.257, z = 43.686},
				Heading    = 90.0
			}
		},

		VehicleDeleters = {
			{x = 462.74, y = -1014.4, z = 27.065},
			{x = 462.40, y = -1019.7, z = 27.104}
		},

		BossActions = {
			{x = 0, y = 0, z = 0}
		}

	}

}