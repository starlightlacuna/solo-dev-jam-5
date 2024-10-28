class_name Firebolt
extends CharacterBody2D

@export var damage: int
@export var bolt_gravity: float
@export var initial_position: Vector2
@export var initial_velocity: Vector2

func initialize(config: BoltData) -> void:
	bolt_gravity = config.gravity
	damage = config.damage
	initial_position = config.initial_position
	initial_velocity = config.initial_velocity

func _ready() -> void:
	set_velocity(initial_velocity)
	set_global_rotation(Vector2.RIGHT.angle_to(initial_velocity))
	set_global_position(initial_position)

func _physics_process(delta: float) -> void:
		var y_speed = bolt_gravity * delta
		var new_velocity: Vector2 = get_velocity() + Vector2(0,  y_speed)
		set_velocity(new_velocity)
		set_global_rotation(Vector2.DOWN.angle_to(new_velocity))
		move_and_slide()
		if get_slide_collision_count() == 0:
			return
		var collision: KinematicCollision2D = get_slide_collision(0)
		if collision.get_collider().has_method("receive_damage"):
			collision.get_collider().receive_damage(damage)
		queue_free()
