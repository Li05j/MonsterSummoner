extends Node

const goblin_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 40,
	"move_spd": 130,
	"max_hp": 91,
	"atk": 8,
	"atk_spd": 0.4,
	"atk_frame": 6,
	"spwn_wait": 0.75,
	"targets": 1,
	"description": "20% chance to summon a BIG goblin.",
}
const slime_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 60,
	"move_spd": 65,
	"max_hp": 43,
	"atk": 67,
	"atk_spd": 2.65,
	"atk_frame": 3,
	"spwn_wait": 0.75,
	"targets": 1,
	"description": "Just a slime.",
}

const iceworm_data = {
	"cc_immune": false,
	"slow_immune": true,
	"cost": 115,
	"move_spd": 80,
	"max_hp": 205,
	"atk": 10,
	"atk_spd": 1.25,
	"atk_frame": 10,
	"spwn_wait": 1.5,
	"targets": 4,
	"description": "Immune to slow.\nSlow (2.0) on hit.",
}

const giant_data = {
	"cc_immune": true,
	"slow_immune": false,
	"cost": 265,
	"move_spd": 35,
	"max_hp": 1500,
	"atk": 12,
	"atk_spd": 4.5,
	"atk_frame": 3,
	"spwn_wait": 3.0,
	"targets": -1,
	"description": "Immune to control.\nKnockback (1.5) on hit.\nDamage reduction: 3.",
}
