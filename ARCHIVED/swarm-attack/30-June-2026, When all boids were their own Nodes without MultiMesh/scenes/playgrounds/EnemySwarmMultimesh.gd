extends SwarmMultiMesh
class_name EnemySwarmMultiMesh

var player: PlayerSwarmMultiMesh

func setup(target_player: PlayerSwarmMultiMesh) -> void:
	player = target_player


func _get_target_position() -> Vector2:
	if player == null:
		return global_position

	return player.get_swarm_center()
