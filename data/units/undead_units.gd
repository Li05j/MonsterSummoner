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
	"description": "(Once) Changes to defence stance (5) when HP < 33%.",
	
	"increased_def": 10,
}
const ghost_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 65,
	"move_spd": 80,
	"max_hp": 64,
	"atk": 21,
	"atk_spd": 1.6,
	"atk_frame": 11,
	"spwn_wait": 0.75,
	"targets": 1,
	"description": "Targets farthest unit.",
}

const undead_witch_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 140,
	"move_spd": 65,
	"max_hp": 165,
	"atk": 16,
	"atk_spd": 1.5,
	"atk_frame": 9,
	"spwn_wait": 1.5,
	"targets": -1,
	"description": "Projectile explodes (0.5x damage) on impact.\n50% to fear (0.75) on hit.",
}

const reaper_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 250,
	"move_spd": 105,
	"max_hp": 375,
	"atk": 40,
	"atk_spd": 3.2,
	"atk_frame": 1,
	"spwn_wait": 3.0,
	"targets": -1,
	"description": "Closest target takes 2x damage.\nExecute on HP < 10%.\nSummon Bats on kill.",
}

const bat_data = {
	"cc_immune": true,
	"slow_immune": false,
	"cost": 0,
	"move_spd": 145,
	"max_hp": 15,
	"atk": 4,
	"atk_spd": 0.25,
	"atk_frame": 4,
	"spwn_wait": 0.5,
	"targets": 1,
	"description": "Reaper's minion.",
}
