extends Node

const ground_y = 530 # global ground
const gravity = 200 # y gravity
const on_spawn_i_frame = 0.75 # i frames in seconds on unit spawn
const hp_bar_visible_time = 3 # how long the hp bar stays visible on hit
const base_death_animation_duration = 4 # how long the base stays on fire before gameover screen appears

enum Who { NONE, ALLY, ENEMY }
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
