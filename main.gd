class_name Main
extends Node2D

@export var game_config: GameConfig
@export var bolt_config: ProjectileConfig

@onready var enemy: Enemy = $Enemy
@onready var player: Player = $Player
@onready var ui: UI = $UI

func _ready() -> void:
	Event.player_tower_destroyed.connect(_on_player_tower_destroyed)
	Event.enemy_tower_destroyed.connect(_on_enemy_tower_destroyed)
	
	var initializable: Array = [ui, enemy]
	for node in initializable:
		node.initialize(game_config)
	player.initialize(game_config, bolt_config)

func _on_enemy_tower_destroyed() -> void:
	print("Enemy tower destroyed!")

func _on_player_tower_destroyed() -> void:
	print("Player tower destroyed!")
