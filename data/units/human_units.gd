extends Node

const adventurer_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 40,
	"move_spd": 90,
	"max_hp": 49,
	"atk": 11,
	"atk_spd": 2.0,
	"atk_frame1": 2,
	"atk_frame2": 8,
	"atk_frame3": 13,
	"spwn_wait": 0.75,
	"targets": 1,
	"description": "An ambitious adventurer.",
}

const mage_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 80,
	"move_spd": 65,
	"max_hp": 110,
	"atk": 14,
	"atk_spd": 3.9,
	"atk_frame": 2,
	"spwn_wait": 0.75,
	"targets": 2,
	"description": "Stun (2) on hit.",
	
	"stun_time": 2,
}

const guardian_data = {
	"cc_immune": true,
	"slow_immune": false,
	"cost": 120,
	"move_spd": 80,
	"max_hp": 75,
	"atk": 8,
	"atk_spd": 1.5,
	"atk_frame1": 2,
	"atk_frame2": 5,
	"atk_frame3": 8,
	"atk_frame4": 11,
	"spwn_wait": 1.5,
	"targets": -1,
	"description": "Immune to control.\n(Once) Jumps in and stun (2).",
	
	"stun_time": 2,
}

const king_data = {
	"cc_immune": false,
	"slow_immune": true,
	"cost": 300,
	"move_spd": 75,
	"max_hp": 195,
	"atk": 13,
	"atk_spd": 1.35,
	"atk_frame1": 2,
	"atk_frame2": 6,
	"spwn_wait": 3.0,
	"targets": -1,
	"description": "Immune to slow.\nHeals all allies on spawn.\nBecomes bigger when HP < 50%.",
	
	"heal_amount": 50,
	"threshold": 0.5,
}
