extends Node2D

var enemies = null
var player = null
var diamond = null
# Called when the node enters the scene tree for the first time.
func _ready():
	enemies = get_tree().get_nodes_in_group('enemies')
	player = get_tree().get_first_node_in_group('player')
	diamond = get_tree().get_first_node_in_group('diamond')
	print("player name: "+player.name)
	for enemy in enemies:
		print(enemy.name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var dist_to_player:float = INF
	var dist_to_diamond:float = INF
	for enemy in enemies:
		if is_instance_valid(enemy):
			if is_instance_valid(player):
				dist_to_player = enemy.global_position.distance_to(player.global_position)
			if is_instance_valid(diamond):
				dist_to_diamond = enemy.global_position.distance_to(diamond.global_position)
			if dist_to_diamond==INF and dist_to_player==INF:
				continue
			if dist_to_player < dist_to_diamond:
				enemy.navigation_agent.target_position = player.global_position
			else:
				enemy.navigation_agent.target_position = diamond.global_position
