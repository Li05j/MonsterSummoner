extends Node

const skeleton_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 50,
	"move_spd": 55,
	"max_hp": 150,
	"atk": 19,
	"atk_spd": 2.7,
	"atk_frame": 6,
	"spwn_wait": 0.75,
	"targets": 2,
	"description": "(Once) Changes to defence stance (5) when HP < 50%.",
	
	"increased_def": 10,
	"threshold": 0.5
}
const ghost_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 65,
	"move_spd": 80,
	"max_hp": 69,
	"atk": 16,
	"atk_spd": 0.9,
	"atk_frame": 11,
	"spwn_wait": 0.75,
	"targets": 1,
	"description": "Targets farthest unit.",
}

const undead_witch_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 145,
	"move_spd": 65,
	"max_hp": 145,
	"atk": 10,
	"atk_spd": 1.5,
	"atk_frame": 9,
	"spwn_wait": 1.5,
	"targets": -1,
	"description": "Projectile explodes (0.5x damage) on impact.\n50% to fear (0.5) on hit.",
	
	"fear_duration": 0.5,
}

const reaper_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 250,
	"move_spd": 105,
	"max_hp": 225,
	"atk": 15,
	"atk_spd": 3.3,
	"atk_frame": 1,
	"spwn_wait": 3.0,
	"targets": -1,
	"description": "Closest target takes 3x damage.\nExecute on HP < 20%.\nSummon Bats on kill.",
	
	"execute_threshold": 0.2,
}

const bat_data = {
	"cc_immune": true,
	"slow_immune": false,
	"cost": 0,
	"move_spd": 145,
	"max_hp": 8,
	"atk": 2,
	"atk_spd": 0.25,
	"atk_frame": 4,
	"spwn_wait": 0.5,
	"targets": 1,
	"description": "Reaper's minion.",
}
