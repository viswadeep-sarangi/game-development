extends CharacterBody2D

# Tank movement speed (pixels per second)
@export var move_speed: float = 10.0
@export var rotation_speed: float = 100.0
@export var bullet_scene: PackedScene
@export var max_health:int = 2
var health:float

@onready var fire_point = $tank_moving_parts/tank_rod/tank_firing_thing
@onready var animation_helper = $_animation_helper
@onready var fire_cooldown_timer: Timer = $fire_cooldown_timer
@onready var health_bar:ColorRect = $canvas_layer/health_bar
var tank_velocity: Vector2 = Vector2.ZERO
var is_turning_direction:int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health*0.99
	set_health_bar()

func fire_normal_bullet():
	var bullet = bullet_scene.instantiate()
	bullet.position = fire_point.global_position
	bullet.rotation = fire_point.global_rotation
	get_tree().current_scene.add_child(bullet)
		
func check_firing_controls():
	if fire_cooldown_timer.is_stopped():
		if Input.is_action_just_pressed('normal_fire'):
			fire_normal_bullet()
			fire_cooldown_timer.start()
		elif Input.is_action_just_pressed('special_fire'):
			print("Special Fire")
			fire_cooldown_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	check_firing_controls()

func _physics_process(_delta):	
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
	
func hit(hit_point:int):
	health-=hit_point
	print('PLAYER has been hit')
	get_tree().call_group("signal_emitters", "receive_signal", "player_hit")
	set_health_bar()
	
func set_health_bar():
	health_bar.color = Color(
		1-(health/max_health), (health/max_health), 0
	)
	health_bar.scale.x = health/max_health
