class_name Bolt
extends CharacterBody2D

enum State { MOVING, STATIONARY }

@export var damage: int
@export var bolt_gravity: float
@export var initial_position: Vector2
@export var initial_velocity: Vector2

var current_state: State

func initialize(config: BoltConfig) -> void:
	bolt_gravity = config.gravity
	damage = config.damage
	initial_position = config.initial_position
	initial_velocity = config.initial_velocity

func _ready() -> void:
	current_state = State.MOVING
	set_velocity(initial_velocity)
	set_global_rotation(Vector2.RIGHT.angle_to(initial_velocity))
	set_global_position(initial_position)

func _physics_process(delta: float) -> void:
	if current_state == State.MOVING:
		var y_speed = bolt_gravity * delta
		var new_velocity: Vector2 = get_velocity() + Vector2(0,  y_speed)
		set_velocity(new_velocity)
		set_global_rotation(Vector2.RIGHT.angle_to(new_velocity))
		move_and_slide()
		if get_slide_collision_count() > 0:
			current_state = State.STATIONARY
	else:
		# BONUS TODO: Let the bolt stay on the field for a short time after it lands
		queue_free()

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.has_method("receive_damage"):
		body.receive_damage(damage)
