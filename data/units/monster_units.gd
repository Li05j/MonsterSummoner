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
	"max_hp": 41,
	"atk": 50,
	"atk_spd": 2.5,
	"atk_frame": 3,
	"spwn_wait": 0.75,
	"targets": 1,
	"description": "Just a slime.",
}

const iceworm_data = {
	"cc_immune": false,
	"slow_immune": true,
	"cost": 120,
	"move_spd": 80,
	"max_hp": 175,
	"atk": 4,
	"atk_spd": 1.5,
	"atk_frame": 10,
	"spwn_wait": 1.5,
	"targets": 5,
	"description": "Immune to slow.\nSlow (1.35) on hit.",
}

const giant_data = {
	"cc_immune": true,
	"slow_immune": false,
	"cost": 275,
	"move_spd": 35,
	"max_hp": 727,
	"atk": 10,
	"atk_spd": 5.0,
	"atk_frame": 3,
	"spwn_wait": 3.0,
	"targets": -1,
	"description": "Immune to control.\nKnockback (1.2) on hit.\nDamage reduction: 5.",
	
	"def": 5,
	"knockback_time": 1.2
}
