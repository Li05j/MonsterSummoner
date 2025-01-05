extends Node

const skeleton_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 50,
	"move_spd": 55,
	"max_hp": 160,
	"atk": 19,
	"atk_spd": 2.7,
	"atk_frame": 6,
	"spwn_wait": 0.75,
	"targets": 1,
	"description": "(Once) Changes to defence stance (4) when HP < 33%.",
}
const ghost_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 65,
	"move_spd": 80,
	"max_hp": 65,
	"atk": 20,
	"atk_spd": 1.45,
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
	"max_hp": 155,
	"atk": 18,
	"atk_spd": 1.5,
	"atk_frame": 9,
	"spwn_wait": 1.5,
	"targets": -1,
	"description": "Projectile explodes (0.5x damage) on impact.\n50% to fear (0.75) on hit.",
}

const death_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 275,
	"move_spd": 105,
	"max_hp": 727,
	"atk": 20,
	"atk_spd": 2.2,
	"atk_frame": 0,
	"spwn_wait": 3.0,
	"targets": -1,
	"description": "Closest target takes 2x damage.\nExecute on HP < 10%.\nSummon Bats on kill.",
}

const bats_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 275,
	"move_spd": 105,
	"max_hp": 727,
	"atk": 20,
	"atk_spd": 2.2,
	"atk_frame": 0,
	"spwn_wait": 3.0,
	"targets": -1,
	"description": "Closest target takes 2x damage.\nExecute on HP < 10%.\nSummon Bats on kill.",
}
