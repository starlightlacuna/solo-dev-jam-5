class_name UI
extends Control

@onready var player_tower_health_bar: ProgressBar = $PlayerTowerHealthBar
@onready var enemy_tower_health_bar: ProgressBar = $EnemyTowerHealthBar
@onready var resource_label: Label = $ResourceLabel
@onready var peasant_button: Button = $UnitsContainer/PeasantButton
@onready var knight_button: Button = $UnitsContainer/KnightButton

var peasant_cost: int
var knight_cost: int
var wizard_cost: int

func _ready() -> void:
	Event.enemy_tower_health_changed.connect(_on_enemy_tower_health_changed)
	Event.player_tower_health_changed.connect(_on_player_tower_health_changed)
	Event.resource_amount_changed.connect(_on_resource_amount_changed)

func _on_enemy_tower_health_changed(value: int) -> void:
	enemy_tower_health_bar.set_value(value)
	
func _on_player_tower_health_changed(value: int) -> void:
	player_tower_health_bar.set_value(value)

func _on_resource_amount_changed(value: int) -> void:
	resource_label.set_text(str(value))

func _on_shoot_button_toggled(toggled_on: bool) -> void:
	Event.shoot_button_toggled.emit(toggled_on)

func initialize(game_config: GameConfig) -> void:
	enemy_tower_health_bar.set_max(game_config.enemy_tower_max_health)
	player_tower_health_bar.set_max(game_config.player_tower_max_health)
	_on_resource_amount_changed(game_config.player_resource_amount)
	
	peasant_cost = game_config.peasant_cost
	knight_cost = game_config.knight_cost
	
	peasant_button.set_text("Peasant\n%d" % peasant_cost)
	knight_button.set_text("Knight\n%d" % knight_cost)
	
	
