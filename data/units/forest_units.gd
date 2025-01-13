extends Node

const forestmage_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 45,
	"move_spd": 65,
	"max_hp": 107,
	"atk": 4,
	"atk_spd": 2.7,
	"atk_frame": 4,
	"spwn_wait": 0.75,
	"targets": -1,
	"description": "Heal all allies in range.\nSlow (0.5) on hit.",
	
	"slow_time": 0.5,
}

const ranger_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 80,
	"move_spd": 90,
	"max_hp": 57,
	"atk": 7,
	"atk_spd": 0.65,
	"atk_frame": 4,
	"spwn_wait": 0.75,
	"targets": 1,
	"description": "Deals 5x damage every 5th attack.",
}

const protector_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 130,
	"move_spd": 55,
	"max_hp": 150,
	"atk": 4,
	"atk_spd": 2.5,
	"atk_frame": 4,
	"spwn_wait": 1.5,
	"targets": -1,
	"description": "Creates an obsticle instead of dying on death.\nKnockback (0.5) on hit.",
	
	"knockback_time": 0.5,
}

const highelf_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 230,
	"move_spd": 80,
	"max_hp": 165,
	"atk": 5,
	"atk_spd": 2.0,
	"atk_frame": 9,
	"spwn_wait": 3.0,
	"targets": -1,
	"description": "Closest target takes 5x damage.\nDodge every 20 seconds.\nKnockback (0.5) on hit.",
	
	"knockback_time": 0.5,
	"dodge_cd": 20,
}
