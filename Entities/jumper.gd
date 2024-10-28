class_name Jumper
extends CharacterBody2D

enum State { WALKING, ATTACKING, JUMPING }

@export var config: CreatureConfig
@export var jump_speed: float = 100

var health: int
var max_health: int
var attack_damage: int
var move_speed: float
var gravity: float
var current_state: State
var can_attack: bool
var attack_targets: Array
var jumped: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area2D = $AttackArea
@onready var attack_timer: Timer = $AttackTimer
@onready var floor_detection_area: Area2D = $FloorDetectionArea
@onready var floor_detection_timer: Timer = $FloorDetectionTimer

func _ready() -> void:
	if config:
		initialize(config)
	current_state = State.WALKING
	can_attack = true

func _physics_process(delta: float) -> void:
	if current_state == State.JUMPING:
		var x_speed: float = -(move_speed * lerp(0.5, 1.0, float(health) / float(max_health)))
		var y_speed: float = get_velocity().y + gravity * delta
		if not jumped:
			y_speed = -jump_speed
			jumped = true
			floor_detection_timer.start()
		set_velocity(Vector2(x_speed, y_speed))
		move_and_slide()
	else:
		attack_targets = attack_area.get_overlapping_bodies()
		if attack_targets.size() > 0:
			if can_attack:
				current_state = State.ATTACKING
				can_attack = false
				animation_player.play("Attack")
		else:
			current_state = State.WALKING
	
		var x_speed: float = -(move_speed * lerp(0.5, 1.0, float(health) / float(max_health)))
		var y_speed: float = get_velocity().y + gravity * delta
		if current_state == State.ATTACKING:
			x_speed = 0.0
		
		set_velocity(Vector2(x_speed, y_speed))
		move_and_slide()

func _on_attack_timer_timeout() -> void:
	can_attack = true

func _on_floor_detection_area_body_entered(_body: Node2D) -> void:
	floor_detection_area.set_deferred("monitoring", false)
	current_state = State.WALKING

func _on_floor_detection_timer_timeout() -> void:
	floor_detection_area.set_monitoring(true)
	
func _on_jump_area_body_entered(_body: Node2D) -> void:
	if not jumped:
		current_state = State.JUMPING

# BONUS TODO: Set up knockback and invulnerability frames
func initialize(p_config: CreatureConfig) -> void:
	max_health = p_config.max_health
	health = max_health
	attack_damage = p_config.attack_damage
	move_speed = p_config.move_speed
	gravity = p_config.gravity
	attack_timer.set_wait_time(p_config.attack_cooldown)

func deal_damage() -> void:
	for target in attack_targets:
		if target.has_method("receive_damage"):
			target.receive_damage(attack_damage)

func receive_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()

func start_attack_cooldown() -> void:
	attack_timer.start()
