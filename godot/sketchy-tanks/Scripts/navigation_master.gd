extends Node2D

var enemies = null
var player = null
# Called when the node enters the scene tree for the first time.
func _ready():
	enemies = get_tree().get_nodes_in_group('enemies')
	player = get_tree().get_first_node_in_group('player')
	print("player name: "+player.name)
	for enemy in enemies:
		print(enemy.name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for enemy in enemies:
		enemy.navigation_agent.target_position = player.global_position
