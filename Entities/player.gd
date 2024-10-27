class_name Player
extends Node2D

@onready var tower: Tower = $Tower
@onready var ballista: Node2D = %Ballista
@onready var bolt_source: Marker2D = ballista.get_node("BoltSource")
@onready var ballista_attack_timer: Timer = ballista.get_node("AttackTimer")
@onready var bolts: Node = $Bolts
@onready var resource_timer: Timer = $ResourceTimer
const bolt_scene: PackedScene = preload("res://Entities/bolt.tscn")

#region Game Settings
var ballista_min_angle: float
var ballista_max_angle: float
var ballista_angular_speed: float
var bolt_speed: float
var bolt_damage: int
var bolt_gravity: float
var resource_gain: int
#endregion

var can_ballista_shoot: bool = true
var shoot_ballista: bool = false
var raise_ballista: bool = false
var lower_ballista: bool = false

var resource_amount: int:
	set(value):
		resource_amount = value
		Event.resource_amount_changed.emit(value)

func _process(delta: float) -> void:
	if shoot_ballista and can_ballista_shoot:
		if resource_amount >= 5:
			resource_amount -= 5
			spawn_bolt()
	if raise_ballista:
		var new_angle: float = clampf(
			ballista.get_global_rotation_degrees() - ballista_angular_speed * delta,
			ballista_min_angle,
			ballista_max_angle
		)
		ballista.set_global_rotation_degrees(new_angle)
	elif lower_ballista:
		var new_angle: float = clampf(
			ballista.get_global_rotation_degrees() + ballista_angular_speed * delta,
			ballista_min_angle,
			ballista_max_angle
		)
		ballista.set_global_rotation_degrees(new_angle)

func _on_attack_timer_timeout() -> void:
	can_ballista_shoot = true

func _on_resource_timer_timeout() -> void:
	resource_amount += resource_gain

#region Button Handlers
# These are code crimes. I think that ideally we wouldn't be connected directly
# to the buttons, but there's no time for setting up a signal bubble chain.
func _on_lower_button_button_down() -> void:
	lower_ballista = true

func _on_lower_button_button_up() -> void:
	lower_ballista = false

func _on_raise_button_button_down() -> void:
	raise_ballista = true

func _on_raise_button_button_up() -> void:
	raise_ballista = false

func _on_shoot_button_toggled(toggled_on: bool) -> void:
	shoot_ballista = toggled_on
#endregion
	
func initialize(game_config: GameConfig) -> void:
	tower.initialize(game_config.player_tower_max_health)
	ballista_attack_timer.set_wait_time(game_config.ballista_attack_cooldown)
	ballista.set_global_rotation_degrees(game_config.ballista_start_angle)
	ballista_min_angle = game_config.ballista_min_angle
	ballista_max_angle = game_config.ballista_max_angle
	ballista_angular_speed = game_config.ballista_angular_speed
	bolt_speed = game_config.bolt_speed
	bolt_damage = game_config.bolt_damage
	bolt_gravity = game_config.bolt_gravity
	resource_amount = game_config.player_resource_amount
	resource_gain = game_config.player_resource_gain
	resource_timer.set_wait_time(game_config.player_resource_cooldown)

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
