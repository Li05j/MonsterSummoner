class_name BattleUnit extends Unit

@onready var _hp_bar: TextureProgressBar = $HpBar

##########################################################
##### States #####

##### Stats #####

var _max_hp: int = 1
var _current_hp: int = 1

var _dmg_rate: float = 1.0

###########################################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_stats()
	_init_timers()
	_init_collisions()
	_init_misc()
	_connect_signals()

func _init_misc() -> void:
	super()
	_current_hp = _max_hp
	_hp_bar.max_value = _max_hp
	_hp_bar.value = _current_hp

func _hurt_reaction() -> void:
	_hp_bar.value = _current_hp

func _heal_reaction() -> void:
	_hp_bar.value = _current_hp

func _counter(other) -> void:
	pass

###########################################################

func _final_heal(amount: int) -> int:
	return amount

func _final_damage(damage: int) -> int:
	return max(1, damage * _dmg_rate)

###########################################################

func get_hp_percent() -> float:
	if _is_dead or !_current_hp or !_max_hp:
		return 0.0
	return float(_current_hp) / float(_max_hp)

func heal(amount: int) -> void:
	if _not_interactable or _is_dead:
		return
		
	_current_hp += _final_heal(amount)
	_heal_reaction()
	if _current_hp > _max_hp:
		_current_hp = _max_hp

# true if dead
func _take_dmg(damage: int, attacker = null) -> bool:
	if _not_interactable || _is_invincible || _is_dead:
		return false # they don't take damage
	
	_counter(attacker)
	_current_hp -= _final_damage(damage)
	_hurt_reaction()
	if _current_hp <= 0:
		_dead()
		return true
	return false
