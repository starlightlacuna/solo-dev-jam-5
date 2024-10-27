class_name Enemy
extends Node2D

@onready var tower: Tower = $Tower

func initialize(game_config: GameConfig) -> void:
	tower.initialize(game_config.enemy_tower_max_health)
