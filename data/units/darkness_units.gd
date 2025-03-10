extends Node

const shadowarcher_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 35,
	"move_spd": 85,
	"max_hp": 44,
	"atk": 5,
	"atk_spd": 1.65,
	"atk_frame": 6,
	"spwn_wait": 0.75,
	"targets": 1,
	"description": "Shoot 2 times.\n25% to stun (1.0) on hit.",
}
const nightborne_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 70,
	"move_spd": 100,
	"max_hp": 74,
	"atk": 11,
	"atk_spd": 1.5,
	"atk_frame": 9,
	"spwn_wait": 0.75,
	"targets": 2,
	"description": "(Once) Dashes when HP < 75%.\nExplode on death.",
}

const darkknight_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 145,
	"move_spd": 35,
	"max_hp": 285,
	"atk": 32,
	"atk_spd": 4.5,
	"atk_frame": 4,
	"spwn_wait": 1.5,
	"targets": 1,
	"description": "(Once) Berserks (4) when HP < 33%.",
	
	"threshold": 0.33,
	"duration": 3,
}

const doomsday_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 225,
	"move_spd": 70,
	"max_hp": 200,
	"atk": 32,
	"atk_spd": 2.4,
	"atk_frame": 4,
	"spwn_wait": 1.0,
	"targets": -1,
	"cc_rate": 0.5,
	"description": "Slow and control duration -50%.\nChanges to Melee form when enemy is approaching.",
	
	"melee_atk_rate": 1.5,
	"melee_atk_spd_rate": 0.25,
	"melee_atk_frame": 4,
	"melee_targets": 1,
}
