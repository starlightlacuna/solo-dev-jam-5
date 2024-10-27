class_name Main
extends Node2D

func _ready() -> void:
	Event.player_tower_destroyed.connect(_on_player_tower_destroyed)
	Event.enemy_tower_destroyed.connect(_on_enemy_tower_destroyed)

func _on_enemy_tower_destroyed() -> void:
	print("Enemy tower destroyed!")

func _on_player_tower_destroyed() -> void:
	print("Player tower destroyed!")
