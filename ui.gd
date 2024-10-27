class_name UI
extends Control

@onready var player_tower_health_bar: ProgressBar = $PlayerTowerHealthBar
@onready var enemy_tower_health_bar: ProgressBar = $EnemyTowerHealthBar

func _ready() -> void:
	Event.enemy_tower_health_changed.connect(_on_enemy_tower_health_changed)
	Event.player_tower_health_changed.connect(_on_player_tower_health_changed)

func _on_enemy_tower_health_changed(value: int) -> void:
	enemy_tower_health_bar.set_value(value)
	
func _on_player_tower_health_changed(value: int) -> void:
	player_tower_health_bar.set_value(value)

func initialize(game_config: GameConfig) -> void:
	enemy_tower_health_bar.set_max(game_config.enemy_tower_max_health)
	player_tower_health_bar.set_max(game_config.player_tower_max_health)

func _on_shoot_button_toggled(toggled_on: bool) -> void:
	Event.shoot_button_toggled.emit(toggled_on)
