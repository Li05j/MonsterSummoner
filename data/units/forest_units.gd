extends Node

const forestmage_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 45,
	"move_spd": 65,
	"max_hp": 107,
	"atk": 3,
	"atk_spd": 3.4,
	"atk_frame": 4,
	"spwn_wait": 0.75,
	"targets": 1,
	"description": "Heal all allies in range.\nSlow (0.5) on hit.",
}
const ranger_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 75,
	"move_spd": 90,
	"max_hp": 57,
	"atk": 9,
	"atk_spd": 0.65,
	"atk_frame": 4,
	"spwn_wait": 0.75,
	"targets": 1,
	"description": "Deals 5x damage every 5th attack on the same target.",
}

const protector_data = {
	"cc_immune": true,
	"slow_immune": false,
	"cost": 135,
	"move_spd": 55,
	"max_hp": 180,
	"atk": 3,
	"atk_spd": 2.5,
	"atk_frame": 4,
	"spwn_wait": 1.5,
	"targets": -1,
	"description": "Immune to Control.\nTakes 50% less damage on defence stance.",
}

const highelf_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 230,
	"move_spd": 60,
	"max_hp": 165,
	"atk": 12,
	"atk_spd": 2.0,
	"atk_frame": 9,
	"spwn_wait": 3.0,
	"targets": -1,
	"description": "Closest target takes 3x damage.\nDodge every 10 seconds.\nStun (1) on hit.",
}
