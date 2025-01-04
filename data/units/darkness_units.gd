extends Node

const shadowarcher_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 40,
	"move_spd": 85,
	"max_hp": 36,
	"atk": 5,
	"atk_spd": 1.85,
	"atk_frame": 6,
	"spwn_wait": 0.75,
	"targets": 2,
	"description": "Shoot 2 times.\n10% to stun (0.65) on hit.",
}
const nightborne_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 65,
	"move_spd": 100,
	"max_hp": 76,
	"atk": 13,
	"atk_spd": 1.5,
	"atk_frame": 9,
	"spwn_wait": 0.75,
	"targets": 2,
	"description": "(Once) Dashes when HP < 75%.\nExplode on death.",
}

const darkknight_data = {
	"cc_immune": true,
	"slow_immune": false,
	"cost": 150,
	"move_spd": 60,
	"max_hp": 727,
	"atk": 32,
	"atk_spd": 3.6,
	"atk_frame": 4,
	"spwn_wait": 1.5,
	"targets": 1,
	"description": "Immune to control.\n(Once) Berserks (4) when HP < 25%.",
}

const doomsday_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 235,
	"move_spd": 70,
	"max_hp": 450,
	"atk": 24,
	"atk_spd": 2.4,
	"atk_frame": 4,
	"spwn_wait": 3.0,
	"targets": -1,
	"cc_rate": 0.5,
	"description": "Slow and control duration -50%.\nChanges to Melee form when enemy is approaching.",
	
	"melee_atk_rate": 1.5,
	"melee_atk_spd_rate": 0.33,
	"melee_atk_frame": 4,
	"melee_targets": 1,
}
