extends Node2D
class_name SwarmMultiMesh

@export var boid_count := 5000
@export var speed := 250.0
@export var turn_rate := 12.0
@export var spread_radius := 120.0
@export var return_strength := 1.8
@export var swirl_strength := 0.9
@export var boid_scale := Vector2(1.0, 1.0)

@onready var multimesh_instance: MultiMeshInstance2D = $MultiMeshInstance2D

var positions: PackedVector2Array
var velocities: PackedVector2Array
var phases: PackedFloat32Array

func _ready() -> void:
	_setup_arrays()
	_setup_multimesh()


func _process(delta: float) -> void:
	var target_position := get_global_mouse_position()

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


func _update_boids(delta: float, target_position: Vector2) -> void:
	for i in boid_count:
		var position := positions[i]
		var velocity := velocities[i]

		var to_target := target_position - position
		var distance_to_target := to_target.length()

		var desired_direction := Vector2.ZERO

		if distance_to_target > 1.0:
			desired_direction += to_target.normalized() * return_strength

		var tangent := to_target.normalized().rotated(PI / 2.0)
		var wave := sin(Time.get_ticks_msec() * 0.002 + phases[i])
		desired_direction += tangent * wave * swirl_strength

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
