class_name Wizard
extends CharacterBody2D

enum State { WALKING, ATTACKING }

@export var config: CreatureConfig
@export var firebolt_config: ProjectileConfig
@export var firebolt_scene: PackedScene
@export var firebolts_group: Node

var health: int
var max_health: int
var attack_damage: int
var move_speed: float
var gravity: float
var current_state: State
var can_attack: bool
var attack_targets: Array
var firebolt_speed: float
var firebolt_damage: int
var firebolt_gravity: float

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area2D = $AttackArea
@onready var attack_timer: Timer = $AttackTimer
@onready var firebolt_source: Marker2D = $FireboltSource

func _ready() -> void:
	if config and firebolt_config:
		initialize(config, firebolt_config, firebolts_group)
	assert(firebolts_group, "Projectiles Group not set!")
	current_state = State.WALKING
	can_attack = true

func _physics_process(delta: float) -> void:
	attack_targets = attack_area.get_overlapping_bodies()
	if attack_targets.size() > 0:
		current_state = State.ATTACKING
		if can_attack:
			can_attack = false
			animation_player.play("Attack")
	else:
		current_state = State.WALKING
	
	var x_velocity: float
	if current_state == State.WALKING:
		x_velocity = (move_speed * lerp(0.5, 1.0, float(health) / float(max_health)))
	else:
		x_velocity = 0.0
	
	set_velocity(Vector2(x_velocity, get_velocity().y + gravity * delta))
	move_and_slide()

func _on_attack_timer_timeout() -> void:
	can_attack = true

# BONUS TODO: Set up knockback and invulnerability frames
func initialize(
	p_config: CreatureConfig,
	p_firebolt_config: ProjectileConfig,
	p_firebolts_group: Node
) -> void:
	max_health = p_config.max_health
	health = max_health
	attack_damage = p_config.attack_damage
	move_speed = p_config.move_speed
	gravity = p_config.gravity
	firebolt_damage = p_firebolt_config.damage
	firebolt_gravity = p_firebolt_config.gravity
	firebolt_speed = p_firebolt_config.speed
	firebolts_group = p_firebolts_group
	await ready
	attack_timer.set_wait_time(p_config.attack_cooldown)

func receive_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()

func start_attack_cooldown() -> void:
	attack_timer.start()

func spawn_firebolt() -> void:
	var firebolt: Firebolt = firebolt_scene.instantiate()
	var firebolt_velocity = Vector2.RIGHT * firebolt_speed
	var firebolt_data: BoltData = BoltData.new(
		firebolt_damage,
		firebolt_gravity,
		firebolt_velocity,
		firebolt_source.get_global_position()
	)
	firebolt.initialize(firebolt_data)
	firebolts_group.add_child(firebolt)
	can_attack = false
