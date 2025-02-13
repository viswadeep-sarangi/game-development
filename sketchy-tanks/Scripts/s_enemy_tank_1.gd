extends CharacterBody2D

# Tank movement speed (pixels per second)
@export var bullet_scene: PackedScene
@export var explosion_anim:PackedScene
@export var move_speed: float = 2.0
@export var tank_color:Color =  Color(1,0.6,0.4)
@export var tank_bullet_speed:int = 250
@export var health:int = 2
@onready var direction_cooldown_timer:Timer = $direction_cooldown_timer
@onready var fire_point = $tank_moving_parts/tank_rod/tank_firing_thing
@onready var navigation_agent:NavigationAgent2D = $NavigationAgent2D
@onready var animation_helper = $_animation_helper
@onready var fire_cooldown_timer = $fire_cooldown_timer
var tank_velocity: Vector2 = Vector2.ZERO
var current_tank_move:String = ''
var is_turning_direction:int = 0

func modulate_canvas_item(color:Color =tank_color):
	var items = [
		$track_left, $track_right, $tank_base, 
		$tank_moving_parts/tank_rod, $tank_moving_parts/tank_hatch
	]
	for sprite in items:
		sprite.modulate = color
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate_canvas_item()
	
func fire_normal_bullet():
	var bullet = bullet_scene.instantiate()
	bullet.position = fire_point.global_position
	bullet.rotation = fire_point.global_rotation
	bullet.bullet_speed = tank_bullet_speed
	bullet.modulate_bullet_color(tank_color)
	get_tree().current_scene.add_child(bullet)
		
func check_firing_controls():
	if fire_cooldown_timer.is_stopped():
		fire_normal_bullet()
		fire_cooldown_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	check_firing_controls()
	
func move_tank(direction: Vector2):
	var s:String = ''
	if abs(direction.x) > abs(direction.y):
		s = 'move_right' if direction.x>0 else 'move_left'
	else:
		s = 'move_down' if direction.y>0 else 'move_up'
		
	if s!=current_tank_move:
		if not direction_cooldown_timer.is_stopped():
			s = current_tank_move
		else:
			direction_cooldown_timer.start()
	if s=="move_left":
		rotation_degrees = -90
		velocity.x = -move_speed
	elif s=="move_right":
		rotation_degrees = 90
		velocity.x = move_speed
	elif s=="move_up":
		rotation_degrees = 0
		velocity.y = -move_speed
	elif s=="move_down":
		rotation_degrees = 180
		velocity.y = move_speed
	current_tank_move = s

func _physics_process(_delta):	
	# Reset velocity
	velocity = Vector2.ZERO
	# Check if Nav target has been set
	if not navigation_agent.is_navigation_finished():
		var next_point = navigation_agent.get_next_path_position()
		var direction = (next_point - global_position).normalized()
		move_tank(direction)
	# Apply movement
	move_and_collide(velocity)
	animation_helper.update_velocity(velocity, is_turning_direction)
	
func hit(hit_point:int):
	health-=hit_point
	if health<=0:
		print(name+' has been hit and is now dead')
		var boom:Node2D = explosion_anim.instantiate()		
		get_parent().add_child(boom)
		boom.global_position = global_position
		get_tree().call_group("signal_emitters", "receive_signal", "enemy_died")
		queue_free()
