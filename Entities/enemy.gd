class_name Enemy
extends Node2D

const SKELLY: String = "Skelly"
const BRUTE: String = "Brute"
const JUMPER: String = "Jumper"

@export var wave_delay: float = 8.0
@export var wave_counter: int = 0
@export var initial_wave_delay: float = 1.0

@export_group("Creatures")
@export var skelly_scene: PackedScene
@export var skelly_config: CreatureConfig
@export var brute_scene: PackedScene
@export var brute_config: CreatureConfig
@export var jumper_scene: PackedScene
@export var jumper_config: CreatureConfig


@onready var tower: Tower = $Tower
@onready var spawner: Marker2D = $Spawner
@onready var wave_timer: Timer = $WaveTimer
@onready var creatures: Node = $Creatures

var current_wave: Array
var spawn_index: int = 0
var wave_index: int = 0
var easy_waves: Array = [
	[SKELLY, 1.6, SKELLY, 0.8, SKELLY, 1.6, SKELLY],
	[SKELLY, 0.8, SKELLY, 0.8, SKELLY, 0.8, SKELLY],
	[SKELLY, 0.8, SKELLY, 0.8, SKELLY]
]
var medium_waves: Array = [
	[]
]
var hard_waves: Array = [[]]

func _ready() -> void:
	assert(skelly_scene, "Skelly Scene not set!")
	assert(skelly_config, "Skelly Config not set!")
	assert(brute_scene, "Brute Scene not set!")
	assert(brute_config, "Brute Config not set!")
	assert(jumper_scene, "Jumper Scene not set!")
	assert(jumper_config, "Jumper Config not set!")

func _get_wave_array() -> Array:
	var index: int
	if wave_counter > 16:
		index = randi_range(0, hard_waves.size() - 1)
		return hard_waves[index]
	if wave_counter > 8:
		index = randi_range(0, medium_waves.size() - 1)
		return medium_waves[index]
	index = randi_range(0, easy_waves.size() - 1)
	return easy_waves[index]

func _on_wave_timer_timeout() -> void:
	if spawn_index >= current_wave.size():
		current_wave = _get_wave_array()
		spawn_index = 0
		wave_counter += 1
		wave_timer.set_wait_time(wave_delay)
		wave_timer.start()
		return
	
	var current_step = current_wave[spawn_index]
	print(current_step)
	match current_step:
		SKELLY:
			var skelly: Skelly = skelly_scene.instantiate()
			skelly.initialize(skelly_config)
			skelly.set_global_position(spawner.get_global_position())
			creatures.add_child(skelly)
		BRUTE:
			print(BRUTE)
		JUMPER:
			print(JUMPER)
	
	spawn_index += 1
	if spawn_index < current_wave.size():
		wave_timer.set_wait_time(current_wave[spawn_index])
		spawn_index += 1
	wave_timer.start()

func initialize(game_config: GameConfig) -> void:
	tower.initialize(game_config.enemy_tower_max_health)
	current_wave = _get_wave_array()
	wave_timer.set_wait_time(initial_wave_delay)
	wave_timer.start()
