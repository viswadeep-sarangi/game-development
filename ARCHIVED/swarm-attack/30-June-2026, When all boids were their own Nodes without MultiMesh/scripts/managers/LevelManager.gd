extends Node

class_name LevelManager

@onready var enemy_swarm_scene = preload("res://scenes/enemy/enemy_swarm.tscn")

var current_level = Constants.STARTING_LEVEL
var current_wave = 0
var current_enemy_swarms = []
var player_swarm = null
var wave_timer = 0.0
var wave_spawned = false

func _ready():
	SignalHub.level_started.connect(_on_level_started)
	SignalHub.enemy_swarm_eliminated.connect(_on_enemy_swarm_eliminated)

func _process(delta):
	wave_timer += delta

	# Spawn next wave if enough time has passed and current wave is dead
	if wave_spawned and get_active_enemy_count() == 0:
		start_next_wave()

func start_level(level: int):
	current_level = level
	current_wave = 0
	SignalHub.level_started.emit(level)
	start_next_wave()

func start_next_wave():
	current_wave += 1

	if current_wave > Constants.WAVES_PER_LEVEL:
		SignalHub.level_completed.emit()
		return

	SignalHub.wave_started.emit(current_wave)
	wave_timer = 0.0
	wave_spawned = true

	# Get wave config or default
	var config = Constants.WAVE_CONFIGS.get(current_level, Constants.WAVE_CONFIGS.get(1))

	if current_wave <= config.size():
		var wave_config = config[current_wave - 1]
		spawn_enemy_swarm(wave_config["enemy_count"])

func spawn_enemy_swarm(unit_count: int):
	var swarm = enemy_swarm_scene.instantiate()
	swarm.wave_number = current_wave
	get_tree().root.add_child(swarm)
	swarm.spawn_units(unit_count)

	# Set target to player swarm center
	if player_swarm:
		swarm.set_target(player_swarm.get_swarm_center())

	current_enemy_swarms.append(swarm)

func get_active_enemy_count() -> int:
	var count = 0
	for swarm in current_enemy_swarms:
		if is_instance_valid(swarm):
			count += swarm.get_alive_unit_count()

	return count

func _on_level_started(level: int):
	current_level = level

func _on_enemy_swarm_eliminated(swarm: Node2D):
	current_enemy_swarms = current_enemy_swarms.filter(func(s): return is_instance_valid(s))
