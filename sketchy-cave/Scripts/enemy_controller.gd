extends CharacterBody2D

class_name EnemyController

@export var speed:float = 100.0

var nav_agent:NavigationAgent2D
var player: CharacterBody2D  # Reference to the player
#var nav_region_cave_map:NavigationRegion2D
#var map_ready:bool = false

func _ready():
	#nav_region_cave_map = get_tree().get_first_node_in_group(">>>game_play_level_map").get_node('NavigationRegion')
	#if nav_region_cave_map:
		#nav_region_cave_map.bake_finished.connect(_on_map_ready)
	
	nav_agent = NavigationAgent2D.new()
	add_child(nav_agent)  # Attach it to the enemy	
	# Configure NavigationAgent2D properties
	nav_agent.path_desired_distance = 4.0  # Distance threshold before stopping
	nav_agent.target_desired_distance = 4.0  # Distance from target before stopping
	
	# Find the player in the scene by name
	player = get_tree().get_first_node_in_group(">>>game_play_level_player")
	if player:
		nav_agent.target_position = player.global_position  # Set target

func _physics_process(delta: float) -> void:
	if player:# and map_ready:
		nav_agent.target_position = player.global_position  # Continuously update target

		# Get the next position on the path
		var next_position = nav_agent.get_next_path_position()
		var direction = (next_position - global_position).normalized()

		velocity = direction * speed
		move_and_slide()
		
#func _on_map_ready() -> void:
	#map_ready = true
