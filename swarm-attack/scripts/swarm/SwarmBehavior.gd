extends Node
class_name SwarmBehavior

static func separation(unit: Node2D, nearby_units: Array, radius: float) -> Vector2:
	var steer := Vector2.ZERO
	var count := 0

	for other_node in nearby_units:
		var other := other_node as Node2D
		if other == null or other == unit:
			continue

		var offset: Vector2 = unit.global_position - other.global_position
		var distance: float = offset.length()

		if distance > 0.0 and distance < radius:
			steer += offset.normalized() / max(distance, 1.0)
			count += 1

	if count == 0:
		return Vector2.ZERO

	steer /= count
	return steer.normalized()


static func cohesion(unit: Node2D, nearby_units: Array, radius: float, target: Vector2) -> Vector2:
	var center := Vector2.ZERO
	var count := 0

	for other in nearby_units:
		if other == unit:
			continue

		var distance := unit.global_position.distance_to(other.global_position)

		if distance > 0.0 and distance < radius:
			center += other.global_position
			count += 1

	var desired_point := target

	if count > 0:
		center /= count
		desired_point = center.lerp(target, 0.35)

	return (desired_point - unit.global_position).normalized()


static func alignment(unit: Node2D, nearby_units: Array, radius: float) -> Vector2:
	var avg_velocity := Vector2.ZERO
	var count := 0

	for other in nearby_units:
		if other == unit:
			continue

		var distance := unit.global_position.distance_to(other.global_position)

		if distance > 0.0 and distance < radius:
			if other.has_meta("velocity"):
				avg_velocity += other.get_meta("velocity")
				count += 1

	if count == 0:
		return Vector2.ZERO

	avg_velocity /= count
	return avg_velocity.normalized()
