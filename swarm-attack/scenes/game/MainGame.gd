extends Node2D

class_name MainGame

@onready var player_swarm_scene = preload("res://scenes/player/player_swarm.tscn")

var player_swarm = null
var level_manager = null

func _ready():
	# Connect signals
	SignalHub.game_over.connect(_on_game_over)
	SignalHub.level_completed.connect(_on_level_completed)

	# Setup level manager
	level_manager = LevelManager.new()
	add_child(level_manager)

	# Spawn player swarm
	spawn_player_swarm()

	# Start first level
	level_manager.start_level(Constants.STARTING_LEVEL)

func spawn_player_swarm():
	player_swarm = player_swarm_scene.instantiate()
	add_child(player_swarm)
	SignalHub.player_swarm_spawned.emit(player_swarm)

	# Link level manager to player swarm
	if level_manager:
		level_manager.player_swarm = player_swarm

func _process(_delta):
	# Update enemy swarms to target player swarm
	if player_swarm and level_manager:
		var player_center = player_swarm.get_swarm_center()
		for swarm in level_manager.current_enemy_swarms:
			if is_instance_valid(swarm):
				swarm.set_target(player_center)

func _on_game_over():
	print("Game Over!")
	get_tree().paused = true

func _on_level_completed():
	print("Level completed!")
	# Transition to next level
	var next_level = level_manager.current_level + 1
	level_manager.start_level(next_level)
