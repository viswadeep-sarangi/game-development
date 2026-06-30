extends Swarm
class_name EnemySwarm

@onready var debug_player_center = $PlayerSwarmCenter

var player: PlayerSwarm


func setup(target_player: PlayerSwarm) -> void:
	player = target_player


func _get_target_position() -> Vector2:
	if player == null:
		return global_position
	
	var center_pos =  player.get_swarm_center()
	debug_player_center.global_position = center_pos
	print("Player NOT NULL")
	return  center_pos
