class_name BoltConfig
extends RefCounted

var damage: int
var gravity: float
var initial_velocity: Vector2
var initial_position: Vector2

func _init(
	p_damage: int,
	p_gravity: float,
	p_initial_velocity: Vector2,
	p_initial_position: Vector2
) -> void:
	damage = p_damage
	gravity = p_gravity
	initial_position = p_initial_position
	initial_velocity = p_initial_velocity
