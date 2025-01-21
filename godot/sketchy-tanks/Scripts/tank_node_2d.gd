extends CharacterBody2D

# Tank movement speed (pixels per second)
@export var move_speed: float = 10.0
@export var rotation_speed: float = 100.0
@export var bullet_scene: PackedScene
@onready var fire_point = $tank_moving_parts/tank_rod/tank_firing_thing
@onready var animation_helper = $_animation_helper
var tank_velocity: Vector2 = Vector2.ZERO
var is_turning_direction:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func fire_normal_bullet():
	var bullet = bullet_scene.instantiate()
	bullet.position = fire_point.global_position
	bullet.rotation = fire_point.global_rotation
	get_tree().current_scene.add_child(bullet)
		
func check_firing_controls():
	if Input.is_action_just_pressed('normal_fire'):
		fire_normal_bullet()
	elif Input.is_action_just_pressed('special_fire'):
		print("Special Fire")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	check_firing_controls()

func _physics_process(delta):	
	# Reset velocity
	velocity = Vector2.ZERO
	is_turning_direction = 0
	# Handle rotation
	if Input.is_action_pressed("move_left"):
		rotation_degrees = -90
		velocity.x = -move_speed
	elif Input.is_action_pressed("move_right"):
		rotation_degrees = 90
		velocity.x = move_speed
	elif Input.is_action_pressed("move_up"):
		rotation_degrees = 0
		velocity.y = -move_speed
	elif Input.is_action_pressed("move_down"):
		rotation_degrees = 180
		velocity.y = move_speed
		
	#velocity = velocity.normalized()
	# Apply movement
	move_and_collide(velocity)
	animation_helper.update_velocity(velocity, is_turning_direction)
