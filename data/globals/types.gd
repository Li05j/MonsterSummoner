extends Node

enum Who { NONE, ALLY, ENEMY }
enum Animation_Type { NONE, IDLE, RUN, ATTACK, DEATH }
enum Collision { 
	NONE = 0,
	PLAYER_UNIT = 1 << 0, 
	ENEMY_UNIT = 1 << 1, 
	PLAYER_PROJ = 1 << 2, 
	ENEMY_PROJ = 1 << 3,
	PLAYER_BASE = 1 << 4,
	ENEMY_BASE = 1 << 5,
	OTHER = 1 << 6
}
