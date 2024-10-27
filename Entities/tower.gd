class_name Tower
extends StaticBody2D

@export var max_health: int = 100
@export var is_player: bool = false

var current_health: int
var health_changed_signal: Signal
var destroyed_signal: Signal

func _ready() -> void:
	if is_player:
		health_changed_signal = Event.player_tower_health_changed
		destroyed_signal = Event.player_tower_destroyed
	else:
		health_changed_signal = Event.enemy_tower_health_changed
		destroyed_signal = Event.enemy_tower_destroyed

func initialize(p_max_health: int) -> void:
	max_health = p_max_health
	current_health = max_health
	health_changed_signal.emit(current_health)

func receive_damage(amount: int) -> void:
	current_health = max(current_health - amount, 0)
	health_changed_signal.emit(current_health)
	if current_health <= 0:
		destroyed_signal.emit()
		queue_free()
		## TODO: Add destruction animation
