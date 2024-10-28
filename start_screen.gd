extends Control

@export var main_scene: PackedScene

func _ready() -> void:
	assert(main_scene, "Main Scene not set!")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_scene)
