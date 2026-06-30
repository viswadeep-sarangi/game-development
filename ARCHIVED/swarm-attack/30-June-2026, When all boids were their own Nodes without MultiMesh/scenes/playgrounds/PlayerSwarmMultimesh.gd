extends SwarmMultiMesh
class_name PlayerSwarmMultiMesh

func _get_target_position() -> Vector2:
	return get_global_mouse_position()
