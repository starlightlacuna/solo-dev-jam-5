class_name Skelly
extends CharacterBody2D

enum State { WALKING, ATTACKING }

@export var config: CreatureConfig

var health: int
var attack_damage: int
var move_speed: float
var gravity: float
var current_state: State

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if config:
		initialize(config)
	current_state = State.WALKING

func _physics_process(delta: float) -> void:
	if current_state == State.WALKING:
		set_velocity(Vector2(-move_speed, get_velocity().y + gravity * delta))
	move_and_slide()

## ~~TODO: Set up collision layers FOR REAL (add gravity please!)~~
## TODO: Set up player creature/tower detection
## TODO: Set up attack animation and damage function
## BONUS_TODO: Set up knockback and invulnerability frames
func initialize(p_config: CreatureConfig) -> void:
	health = p_config.max_health
	attack_damage = p_config.attack_damage
	move_speed = p_config.move_speed
	gravity = p_config.gravity

func deal_damage() -> void:
	print("Scratch!")
	
