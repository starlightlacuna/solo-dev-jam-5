class_name Player
extends Node2D

@onready var tower: Tower = $Tower
@onready var ballista: Node2D = $Ballista
@onready var bolt_source: Marker2D = $Ballista/BoltSource
@onready var ballista_attack_timer: Timer = $Ballista/AttackTimer
@onready var bolts: Node = $Bolts
const bolt_scene: PackedScene = preload("res://Entities/bolt.tscn")

#region Game Settings
var ballista_min_angle: float
var ballista_max_angle: float
var bolt_speed: float
var bolt_damage: int
var bolt_gravity: float
#endregion

var can_ballista_shoot: bool = true
var ballista_shooting: bool = false

func _on_attack_timer_timeout() -> void:
	can_ballista_shoot = true
	
func initialize(game_config: GameConfig) -> void:
	tower.initialize(game_config.player_tower_max_health)
	ballista_attack_timer.set_wait_time(game_config.ballista_attack_cooldown)
	ballista.set_global_rotation_degrees(game_config.ballista_start_angle)
	ballista_min_angle = game_config.ballista_min_angle
	ballista_max_angle = game_config.ballista_max_angle
	bolt_speed = game_config.bolt_speed
	bolt_damage = game_config.bolt_damage
	bolt_gravity = game_config.bolt_gravity

func spawn_bolt() -> void:
	var bolt: Bolt = bolt_scene.instantiate()
	var bolt_velocity = Vector2.RIGHT.rotated(ballista.get_global_rotation()) * bolt_speed
	var bolt_config: BoltConfig = BoltConfig.new(
		bolt_damage,
		bolt_gravity,
		bolt_velocity,
		bolt_source.get_global_position()
	)
	bolt.initialize(bolt_config)
	bolts.add_child(bolt)
	can_ballista_shoot = false
	ballista_attack_timer.start()
