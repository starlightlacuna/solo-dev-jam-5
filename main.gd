class_name Main
extends Node2D

@onready var enemy: Enemy = $Enemy
@onready var player: Player = $Player
@onready var ui: UI = $UI

func _ready() -> void:
	Event.player_tower_destroyed.connect(_on_player_tower_destroyed)
	Event.enemy_tower_destroyed.connect(_on_enemy_tower_destroyed)
	
	var game_config: GameConfig = preload("res://Data/default_game_config.tres")
	var initializable: Array = [ui, enemy, player]
	for node in initializable:
		node.initialize(game_config)
	
	

func _on_enemy_tower_destroyed() -> void:
	print("Enemy tower destroyed!")

func _on_player_tower_destroyed() -> void:
	print("Player tower destroyed!")
