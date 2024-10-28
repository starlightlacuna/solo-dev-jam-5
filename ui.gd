class_name UI
extends Control

@onready var player_tower_health_bar: ProgressBar = $PlayerTowerHealthBar
@onready var enemy_tower_health_bar: ProgressBar = $EnemyTowerHealthBar
@onready var resource_label: Label = $ResourceLabel
@onready var peasant_button: Button = $UnitsContainer/PeasantButton
@onready var knight_button: Button = $UnitsContainer/KnightButton
@onready var game_over_window: Control = $GameOverWindow
@onready var game_over_label: Label = %GameOverLabel

var peasant_cost: int
var knight_cost: int
var wizard_cost: int

func _ready() -> void:
	Event.enemy_tower_health_changed.connect(_on_enemy_tower_health_changed)
	Event.player_tower_health_changed.connect(_on_player_tower_health_changed)
	Event.resource_amount_changed.connect(_on_resource_amount_changed)
	Event.game_ended.connect(_on_game_ended)
	game_over_window.hide()

func _on_game_ended(win: bool) -> void:
	if win:
		game_over_label.set_text("Well done!\nThe necromancer has been vanquished.")
	else:
		game_over_label.set_text("Better luck next time!")
	game_over_window.show()
	get_tree().set_pause(true)

func _on_enemy_tower_health_changed(value: int) -> void:
	enemy_tower_health_bar.set_value(value)

func _on_player_tower_health_changed(value: int) -> void:
	player_tower_health_bar.set_value(value)

func _on_resource_amount_changed(value: int) -> void:
	resource_label.set_text(str(value))
	
func _on_restart_button_pressed() -> void:
	var tree: SceneTree = get_tree()
	tree.set_pause(false)
	tree.reload_current_scene()

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
	
