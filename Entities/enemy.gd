class_name Enemy
extends Node2D

const SKELLY: String = "Skelly"
const BRUTE: String = "Brute"
const JUMPER: String = "Jumper"

@export var active: bool = true
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
	[SKELLY, 0.8, SKELLY, 0.8, SKELLY],
	[SKELLY, 0.8, SKELLY, 1.6, SKELLY, 0.8, SKELLY]
]
var medium_waves: Array = [
	[SKELLY, 0.8, SKELLY, 0.8, SKELLY, 0.8, SKELLY],
	[BRUTE, 2.4, SKELLY, 0.8, SKELLY, 0.8, SKELLY],
	[SKELLY, 0.8, SKELLY, 0.8, SKELLY, 1.6, SKELLY, 0.8, SKELLY],
	[SKELLY, 0.8, SKELLY, 1.6, SKELLY, 0.8, SKELLY, 0.8, SKELLY],
	[SKELLY, 0.8, SKELLY, 0.8, SKELLY, 0.8, SKELLY, 0.8, BRUTE]
]
var hard_waves: Array = [
	[SKELLY, 0.8, SKELLY, 0.8, SKELLY, 0.8, SKELLY, 0.8, BRUTE],
	[SKELLY, 0.8, SKELLY, 0.8, JUMPER, 0.8, JUMPER],
	[SKELLY, 0.8, SKELLY, 0.8, SKELLY, 1.6, BRUTE, 0.8, JUMPER],
	[SKELLY, 0.4, SKELLY, 0.4, SKELLY, 0.4, SKELLY, 0.4, SKELLY, 0.4, SKELLY],
	[BRUTE, 1.6, JUMPER, 0.8, JUMPER],
	[BRUTE, 2.4, BRUTE],
	[SKELLY, 0.4, SKELLY, 0.4, SKELLY, 1.2, SKELLY, 0.4, SKELLY, 0.4, SKELLY],
]

func _ready() -> void:
	assert(skelly_scene, "Skelly Scene not set!")
	assert(skelly_config, "Skelly Config not set!")
	assert(brute_scene, "Brute Scene not set!")
	assert(brute_config, "Brute Config not set!")
	assert(jumper_scene, "Jumper Scene not set!")
	assert(jumper_config, "Jumper Config not set!")

func _get_wave_array() -> Array:
	var old_array: Array = current_wave
	
	var waves: Array
	if wave_counter > 16:
		waves = hard_waves
	elif wave_counter > 8:
		waves = medium_waves
	else:
		waves = easy_waves
	
	var repeat_count: int = 3
	var index: int
	while repeat_count > 0:
		index = randi_range(0, waves.size() - 1)
		if waves[index] == old_array:
			repeat_count -= 1
		else:
			break
	return waves[index]

func _get_wave_delay() -> float:
	var max_delay: float = 7.5
	var min_delay: float = 4
	# Every 4 waves, the delay decreases by 0.5 seconds until min_delay is reached
	var delay: float = max_delay - (floorf(float(wave_counter) / 4.0) / 2.0)
	return maxf(delay, min_delay)

func _on_wave_timer_timeout() -> void:
	if wave_counter == 0 && spawn_index == 0:
		wave_timer.set_wait_time(_get_wave_delay())
	if spawn_index >= current_wave.size():
		current_wave = _get_wave_array()
		spawn_index = 0
		wave_counter += 1
		var new_wave_delay: float = _get_wave_delay()
		wave_timer.set_wait_time(new_wave_delay)
		wave_timer.start()
		print("Wave %d, delay %f" % [wave_counter, new_wave_delay])
		return
	
	var current_step = current_wave[spawn_index]
	match current_step:
		SKELLY:
			var skelly: Skelly = skelly_scene.instantiate()
			skelly.initialize(skelly_config)
			skelly.set_global_position(spawner.get_global_position())
			creatures.add_child(skelly)
		BRUTE:
			var brute: Brute = brute_scene.instantiate()
			brute.initialize(brute_config)
			brute.set_global_position(spawner.get_global_position())
			creatures.add_child(brute)
		JUMPER:
			var jumper: Jumper = jumper_scene.instantiate()
			jumper.initialize(jumper_config)
			jumper.set_global_position(spawner.get_global_position())
			creatures.add_child(jumper)
	
	# TODO: There's a bug here somewhere. The timer between waves is ever so 
	# slightly longer than the wave times.
	spawn_index += 1
	if spawn_index < current_wave.size():
		wave_timer.set_wait_time(current_wave[spawn_index])
		spawn_index += 1
	wave_timer.start()

func initialize(game_config: GameConfig) -> void:
	tower.initialize(game_config.enemy_tower_max_health)
	if active:
		current_wave = _get_wave_array()
		wave_timer.set_wait_time(initial_wave_delay)
		wave_timer.start()
