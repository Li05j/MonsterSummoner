extends Node

const adventurer_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 40,
	"move_spd": 90,
	"max_hp": 62,
	"atk": 12,
	"atk_spd": 1.85,
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
	"cost": 70,
	"move_spd": 65,
	"max_hp": 90,
	"atk": 6,
	"atk_spd": 6.0,
	"atk_frame": 5,
	"spwn_wait": 0.75,
	"targets": -1,
	"description": "Stun (2) on hit.",
	
	"stun_time": 2,
}

const guardian_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 130,
	"move_spd": 80,
	"max_hp": 85,
	"atk": 5,
	"atk_spd": 1.5,
	"atk_frame1": 2,
	"atk_frame2": 5,
	"atk_frame3": 8,
	"atk_frame4": 11,
	"spwn_wait": 1.5,
	"targets": -1,
	"description": "(Once) Jumps in and stun (2).",
	
	"stun_time": 2,
}

const king_data = {
	"cc_immune": false,
	"slow_immune": true,
	"cost": 300,
	"move_spd": 75,
	"max_hp": 300,
	"atk": 18,
	"atk_spd": 1.45,
	"atk_frame1": 2,
	"atk_frame2": 6,
	"spwn_wait": 3.0,
	"targets": -1,
	"description": "Immune to slow.\nHeals all allies on spawn.\nBecomes bigger when HP < 50%.",
	
	"heal_amount": 100,
	"threshold": 0.5,
}
