extends Node2D

class_name EnemySwarm

@onready var enemy_unit_scene = preload("res://scenes/prefabs/swarm_unit.tscn")

var units = []
var target_position = Vector2.ZERO
var wave_number = 1
var is_eliminated = false

func _ready():
	pass

func _process(_delta):
	# Clean up dead units
	units = units.filter(func(u): return is_instance_valid(u) and u.is_alive)

	# Check if swarm is eliminated
	if not is_eliminated and units.is_empty():
		is_eliminated = true
		SignalHub.enemy_swarm_eliminated.emit(self)

func spawn_units(count: int):
	# Spawn on random edge of screen
	var viewport_rect = get_viewport_rect()
	var spawn_edge = randi() % 4  # 0: top, 1: right, 2: bottom, 3: left

	var spawn_pos = Vector2.ZERO

	match spawn_edge:
		0:  # Top
			spawn_pos = Vector2(randf_range(0, viewport_rect.size.x), -Constants.ENEMY_SPAWN_OFFSET_FROM_SCREEN)
		1:  # Right
			spawn_pos = Vector2(viewport_rect.size.x + Constants.ENEMY_SPAWN_OFFSET_FROM_SCREEN, randf_range(0, viewport_rect.size.y))
		2:  # Bottom
			spawn_pos = Vector2(randf_range(0, viewport_rect.size.x), viewport_rect.size.y + Constants.ENEMY_SPAWN_OFFSET_FROM_SCREEN)
		3:  # Left
			spawn_pos = Vector2(-Constants.ENEMY_SPAWN_OFFSET_FROM_SCREEN, randf_range(0, viewport_rect.size.y))

	for i in range(count):
		spawn_unit(spawn_pos + Vector2(randf_range(-50, 50), randf_range(-50, 50)))

func spawn_unit(pos: Vector2):
	var unit = enemy_unit_scene.instantiate()
	unit.unit_type = "enemy"
	unit.speed = Constants.ENEMY_UNIT_SPEED
	unit.health = Constants.ENEMY_UNIT_HEALTH
	unit.max_health = Constants.ENEMY_UNIT_HEALTH
	unit.global_position = pos

	add_child(unit)
	units.append(unit)
	SignalHub.enemy_unit_spawned.emit(unit)

func set_target(target_pos: Vector2):
	target_position = target_pos
	for unit in units:
		if is_instance_valid(unit):
			unit.set_target(target_pos)

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
