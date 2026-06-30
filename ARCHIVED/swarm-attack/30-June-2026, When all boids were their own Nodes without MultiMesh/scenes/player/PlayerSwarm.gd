extends Node2D

class_name PlayerSwarm

@onready var swarm_unit_scene = preload("res://scenes/prefabs/swarm_unit.tscn")

var units = []
var total_health = 0
var max_total_health = 0
var mouse_position = Vector2.ZERO

func _ready():
	SignalHub.mouse_position_updated.connect(_on_mouse_position_updated)
	spawn_initial_swarm()

func _process(_delta):
	# Update mouse position
	mouse_position = get_global_mouse_position()
	SignalHub.mouse_position_updated.emit(mouse_position)

	# Update all units' target
	for unit in units:
		if is_instance_valid(unit):
			unit.set_target(mouse_position)

	# Clean up dead units
	units = units.filter(func(u): return is_instance_valid(u) and u.is_alive)

	# Update health display
	update_swarm_health()

func spawn_initial_swarm():
	for i in range(75):  # Start with 20 units
		spawn_unit()

func spawn_unit():
	if units.size() >= Constants.PLAYER_SWARM_MAX_UNITS:
		return

	var unit = swarm_unit_scene.instantiate()
	unit.unit_type = "player"
	unit.speed = Constants.PLAYER_UNIT_SPEED
	unit.health = Constants.PLAYER_UNIT_HEALTH
	unit.max_health = Constants.PLAYER_UNIT_HEALTH

	# Random spawn position around screen center
	var viewport_center = get_viewport_rect().get_center()
	unit.global_position = viewport_center + Vector2(randf_range(-100, 100), randf_range(-100, 100))

	add_child(unit)
	units.append(unit)
	SignalHub.player_unit_spawned.emit(unit)
	update_swarm_health()

func get_swarm_center() -> Vector2:
	if units.is_empty():
		return Vector2.ZERO

	var center = Vector2.ZERO
	for unit in units:
		if is_instance_valid(unit):
			center += unit.global_position

	return center / units.size()

func get_alive_unit_count() -> int:
	return units.filter(func(u): return is_instance_valid(u) and u.is_alive).size()

func update_swarm_health():
	total_health = 0
	max_total_health = 0

	for unit in units:
		if is_instance_valid(unit):
			total_health += unit.health
			max_total_health += unit.max_health

	SignalHub.player_swarm_health_changed.emit(total_health, max_total_health)

	if total_health <= 0:
		SignalHub.game_over.emit()

func _on_mouse_position_updated(pos: Vector2):
	mouse_position = pos
