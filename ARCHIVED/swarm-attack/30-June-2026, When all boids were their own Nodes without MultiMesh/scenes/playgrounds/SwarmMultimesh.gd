extends Node2D
class_name SwarmMultiMesh

@export var boid_count := 100
@export var speed := 200.0
@export var turn_rate := 4.0
@export var spread_radius := 300.0
@export var return_strength := 2.0
@export var swirl_strength := 0.5
@export var boid_scale := Vector2(1.0, 1.0)

@onready var multimesh_instance: MultiMeshInstance2D = $MultiMeshInstance2D

# Flocking mechanism
@export var cell_size := 75.0
@export var separation_radius := 25.0
@export var cohesion_radius := 100.0
@export var alignment_radius := 120.0
@export var separation_weight := 5.0
@export var cohesion_weight := 0.25
@export var alignment_weight := 2.0
@export var target_weight := 2.0
@export var max_neighbours_per_boid := 30
var grid := {}

var positions: PackedVector2Array
var velocities: PackedVector2Array
var phases: PackedFloat32Array

func _ready() -> void:
	_setup_arrays()
	_setup_multimesh()

func _get_target_position() -> Vector2:
	return global_position
	

func _process(delta: float) -> void:
	var target_position := _get_target_position()

	_update_boids(delta, target_position)
	_update_multimesh()


func _setup_arrays() -> void:
	positions.resize(boid_count)
	velocities.resize(boid_count)
	phases.resize(boid_count)

	for i in boid_count:
		var angle := randf() * TAU
		var distance := sqrt(randf()) * spread_radius
		var offset := Vector2.RIGHT.rotated(angle) * distance

		positions[i] = global_position + offset
		velocities[i] = Vector2.RIGHT.rotated(angle) * speed
		phases[i] = randf() * TAU


func _setup_multimesh() -> void:
	var quad := QuadMesh.new()
	quad.size = Vector2(24, 24)

	var multi := MultiMesh.new()
	multi.transform_format = MultiMesh.TRANSFORM_2D
	multi.instance_count = boid_count
	multi.mesh = quad

	multimesh_instance.multimesh = multi
	
func _rebuild_grid() -> void:
	grid.clear()
	for i in boid_count:
		var cell := _get_cell(positions[i])

		if not grid.has(cell):
			grid[cell] = []

		grid[cell].append(i)

func _get_cell(pos: Vector2) -> Vector2i:
	return Vector2i(
		floori(pos.x / cell_size),
		floori(pos.y / cell_size)
	)

func _update_boids(delta: float, target_position: Vector2) -> void:
	_rebuild_grid()

	for i in boid_count:
		var position := positions[i]
		var velocity := velocities[i]

		var separation := Vector2.ZERO
		var cohesion := Vector2.ZERO
		var alignment := Vector2.ZERO

		var separation_count := 0
		var cohesion_count := 0
		var alignment_count := 0

		var current_cell := _get_cell(position)

		var checked_neighbours := 0
		for x in range(-1, 2):
			for y in range(-1, 2):
				var neighbour_cell := current_cell + Vector2i(x, y)

				if not grid.has(neighbour_cell):
					continue

				for other_index in grid[neighbour_cell]:
					if other_index == i:
						continue

					checked_neighbours += 1
					
					if checked_neighbours > max_neighbours_per_boid:
						break

					var other_position := positions[other_index]
					var other_velocity := velocities[other_index]

					var offset := position - other_position
					var distance_squared := offset.length_squared()

					if distance_squared <= 0.001:
						continue

					# Separation
					if distance_squared < separation_radius * separation_radius:
						var distance := sqrt(distance_squared)
						var push_strength := 1.0 - (distance / separation_radius)
						separation += offset.normalized() * push_strength
						separation_count += 1

					# Cohesion
					if distance_squared < cohesion_radius * cohesion_radius:
						cohesion += other_position
						cohesion_count += 1

					# Alignment
					if distance_squared < alignment_radius * alignment_radius:
						alignment += other_velocity
						alignment_count += 1

		var desired_direction := Vector2.ZERO

		if separation_count > 0:
			separation /= separation_count
			desired_direction += separation.normalized() * separation_weight

		if cohesion_count > 0:
			cohesion /= cohesion_count
			var to_center := cohesion - position
			if to_center.length() > 0.01:
				desired_direction += to_center.normalized() * cohesion_weight

		if alignment_count > 0:
			alignment /= alignment_count
			if alignment.length() > 0.01:
				desired_direction += alignment.normalized() * alignment_weight

		var to_target := target_position - position
		if to_target.length() > 1.0:
			desired_direction += to_target.normalized() * target_weight

		if desired_direction.length() > 0.01:
			var current_direction := velocity.normalized()
			var target_direction := desired_direction.normalized()

			var new_direction := current_direction.slerp(
				target_direction,
				clamp(turn_rate * delta, 0.0, 1.0)
			)

			velocity = new_direction.normalized() * speed

		position += velocity * delta

		positions[i] = position
		velocities[i] = velocity

func _update_multimesh() -> void:
	var multi := multimesh_instance.multimesh
	if multi == null:
		return

	for i in boid_count:
		var angle := velocities[i].angle()
		var transform := Transform2D(angle, positions[i])
		transform = transform.scaled(boid_scale)

		multi.set_instance_transform_2d(i, transform)

func get_swarm_center() -> Vector2:
	if boid_count <= 0:
		return global_position

	var center := Vector2.ZERO

	for i in boid_count:
		center += positions[i]

	return center / boid_count
