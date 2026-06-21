extends CharacterBody2D

class_name SwarmUnit

@export var unit_type = "player"  # "player" or "enemy"
@export var speed = Constants.PLAYER_UNIT_SPEED
@export var health = Constants.PLAYER_UNIT_HEALTH
var max_health = health

var velocity_vector = Vector2.ZERO
var target_position = global_position
var nearby_units = []
var is_alive = true

func _ready():
	add_to_group(unit_type + "_units")
	set_meta("velocity", velocity_vector)

	if unit_type == "player":
		modulate = Constants.PLAYER_UNIT_COLOR
	else:
		modulate = Constants.ENEMY_UNIT_COLOR

func _physics_process(delta):
	if not is_alive:
		return

	# Get nearby units for flocking
	nearby_units = get_tree().get_nodes_in_group(unit_type + "_units")
	nearby_units = nearby_units.filter(func(u): return u != self and is_instance_valid(u))

	# Apply flocking behavior
	var separation_force = SwarmBehavior.separation(
		self, 
		nearby_units, 
		Constants.PLAYER_UNIT_SEPARATION_RADIUS
	)* Constants.SEPARATION

	var cohesion_force = SwarmBehavior.cohesion(
		self, 
		nearby_units, 
		Constants.PLAYER_UNIT_COHESION_RADIUS, 
		target_position
	)* Constants.COHESION
	
	var alignment_force = SwarmBehavior.alignment(
		self, 
		nearby_units, 
		Constants.PLAYER_UNIT_ALIGNMENT_RADIUS
	)* Constants.ALIGNMENT
	
	var target_force := (target_position - global_position).normalized() * 10.0
	var desired_direction = (
		separation_force +
		cohesion_force +
		alignment_force +
		target_force
	)
	
	if desired_direction.length() > 0.01:
		var desired_velocity = desired_direction.normalized() * speed
		var steering = desired_velocity - velocity
		steering = steering.limit_length(Constants.MAX_FORCE)

		velocity += steering * delta
		velocity = velocity.limit_length(speed)

	set_meta("velocity", velocity)
	
	velocity_vector = velocity
	move_and_slide()
	
	if velocity.length() > 1.0:
		var target_angle := velocity.angle()
		rotation = lerp_angle(rotation, target_angle, Constants.ROTATION_SPEED * delta)

	clamp_to_screen()

func clamp_to_screen():
	var viewport_rect = get_viewport_rect()
	global_position.x = clamp(global_position.x, Constants.SCREEN_MARGIN, viewport_rect.size.x - Constants.SCREEN_MARGIN)
	global_position.y = clamp(global_position.y, Constants.SCREEN_MARGIN, viewport_rect.size.y - Constants.SCREEN_MARGIN)

func set_target(pos: Vector2):
	target_position = pos

func take_damage(damage: float):
	if not is_alive:
		return

	health -= damage
	if health <= 0:
		die()

func die():
	if not is_alive:
		return

	is_alive = false

	if unit_type == "player":
		SignalHub.player_unit_died.emit(self)
	else:
		SignalHub.enemy_unit_died.emit(self)

	queue_free()

func _on_area_entered(area):
	if area is SwarmUnit and area.unit_type != unit_type:
		if area.is_alive:
			SignalHub.collision_detected.emit(self, area)
