extends Node

const ground_y = 530 # global ground
const summon_offset_x = 36

const gravity = 200 # y gravity
const on_spawn_i_frame = 0.75 # i frames in seconds on unit spawn
const hp_bar_visible_time = 3 # how long the hp bar stays visible on hit
const base_death_animation_duration = 4 # how long the base stays on fire before gameover screen appears
const proj_unit_dead_polling_time = 1.0

const max_base_hp = 1000
const ally_base_x = 115 # ally base
const min_enemy_base_x = 1037
const max_enemy_base_x = 2189

enum Who { NONE, ALLY = 1, ENEMY = -1 }
enum Animation_Type { NONE, IDLE, RUN, ATTACK, SPECIAL, DEAD, SPAWN }
enum Collision { 
	NONE = 0,
	PLAYER_UNIT = 1 << 0, 
	ENEMY_UNIT = 1 << 1, 
	PLAYER_PROJ = 1 << 2, 
	ENEMY_PROJ = 1 << 3,
	PLAYER_BASE = 1 << 4,
	ENEMY_BASE = 1 << 5,
	DETECT_ONLY = 1 << 6
}
enum Faction { NONE, MONSTER, DARKNESS, UNDEAD }

func get_gold_drop(base_cost: int) -> int:
	return floor(base_cost / 5.0)
