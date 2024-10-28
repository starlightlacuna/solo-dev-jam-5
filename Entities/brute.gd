class_name Brute
extends CharacterBody2D

enum State { WALKING, ATTACKING }

@export var config: CreatureConfig

var health: int
var max_health: int
var attack_damage: int
var move_speed: float
var gravity: float
var current_state: State
var can_attack: bool
var attack_targets: Array

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area2D = $AttackArea
@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	if config:
		initialize(config)
	current_state = State.WALKING
	can_attack = true

func _physics_process(delta: float) -> void:
	attack_targets = attack_area.get_overlapping_bodies()
	if attack_targets.size() > 0:
		if can_attack:
			current_state = State.ATTACKING
			can_attack = false
			animation_player.play("Attack")
	else:
		current_state = State.WALKING
	
	var x_velocity: float
	if current_state == State.WALKING:
		x_velocity = -(move_speed * lerp(0.5, 1.0, float(health) / float(max_health)))
	else:
		x_velocity = 0.0
	
	set_velocity(Vector2(x_velocity, get_velocity().y + gravity * delta))
	move_and_slide()

func _on_attack_timer_timeout() -> void:
	can_attack = true

# BONUS TODO: Set up knockback and invulnerability frames
func initialize(p_config: CreatureConfig) -> void:
	max_health = p_config.max_health
	health = max_health
	attack_damage = p_config.attack_damage
	move_speed = p_config.move_speed
	gravity = p_config.gravity
	await ready
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
