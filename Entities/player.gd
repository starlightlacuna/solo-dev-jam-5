class_name Player
extends Node2D

@onready var tower: Tower = $Tower

func initialize(game_config: GameConfig) -> void:
	tower.initialize(game_config.player_tower_max_health)
