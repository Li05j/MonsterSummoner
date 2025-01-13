extends Node

const adventurer_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 40,
	"move_spd": 90,
	"max_hp": 72,
	"atk": 8,
	"atk_spd": 1.5,
	"atk_frame1": 0,
	"atk_frame2": 0,
	"atk_frame3": 0,
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
	"atk": 4,
	"atk_spd": 2.2,
	"atk_frame": 4,
	"spwn_wait": 0.75,
	"targets": -1,
	"description": "Stun (1) on hit.",
	
	"stun_time": 1,
}

const guardian_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 135,
	"move_spd": 80,
	"max_hp": 85,
	"atk": 6,
	"atk_spd": 1.5,
	"atk_frame1": 4,
	"atk_frame2": 4,
	"atk_frame3": 4,
	"atk_frame4": 4,
	"spwn_wait": 1.5,
	"targets": -1,
	"description": "(Once) Jumps in and stun (2).",
	
	"stun_time": 2,
}

const king_data = {
	"cc_immune": false,
	"slow_immune": false,
	"cost": 300,
	"move_spd": 75,
	"max_hp": 300,
	"atk": 21,
	"atk_spd": 1.5,
	"atk_frame1": 9,
	"atk_frame2": 9,
	"spwn_wait": 3.0,
	"targets": -1,
	"description": "Heals and berserks (4) all allies on spawn.",
}
