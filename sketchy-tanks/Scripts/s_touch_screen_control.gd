extends Control

@export var joystick_tex:TextureRect
@export var shoot_tex:TextureRect
@export var joystick_radius := 50
@export var shoot_radius :=20
@export var dead_zone:int = 10
@export var shoot_icon_countdown:Timer
@export var line_color:Color = Color(0,0,0,0.5)
var joystick_active := false
var start_position := Vector2.ZERO
var current_position := Vector2.ZERO
var x_half:float

func _draw():
	if joystick_active:
		print("Drawing Line")
		draw_line(
			start_position, 
			current_position+Vector2(joystick_radius/2, joystick_radius/2), 
			line_color, 
			5
		)

func _ready():
	await get_tree().process_frame
	x_half = get_rect().size.x/2
	joystick_tex.visible = false
	shoot_tex.visible=false

# Called when the joystick should track touch
func _input(event):
	#print("Event detected: ",event)
	# Detect touch start
	if event is InputEventScreenTouch and event.pressed:
		if event.position.x<=x_half:
			print("Event is Touch, Pressed at ",event.position)
			joystick_active = true
			start_position = event.position
			current_position = start_position
			joystick_tex.global_position = start_position - Vector2(joystick_radius, joystick_radius)
			joystick_tex.visible = true
		else:
			shoot_icon_countdown.start()
			shoot_tex.global_position = event.position - Vector2(shoot_radius,shoot_radius)
			shoot_tex.visible=true
			Input.action_press("normal_fire")

	# Detect drag
	if event is InputEventScreenDrag and joystick_active:
		print("Event is Touch, Dragged at ",event.position)
		current_position = event.position
		var drag_vector = current_position - start_position
		#var distance = drag_vector.length()
#
		## Constrain the joystick handle within the joystick radius		
		#if distance > joystick_radius:
			#drag_vector = drag_vector.normalized() * joystick_radius

		joystick_tex.global_position = current_position - Vector2(joystick_radius, joystick_radius)
		# Determine direction based on drag
		handle_direction(drag_vector)
		queue_redraw()

	# Detect touch release
	if event is InputEventScreenTouch and not event.pressed:
		if joystick_active:
			print("Event is Touch, Released at ",event.position)
			queue_redraw()
			reset_joystick()

# Handle direction based on drag vector
func handle_direction(drag_vector: Vector2):
	# Reset actions
	Input.action_release("move_up")
	Input.action_release("move_down")
	Input.action_release("move_left")
	Input.action_release("move_right")

	# Apply directional input
	if drag_vector.length() > 20:  # Deadzone
		var angle = drag_vector.angle()
		if abs(angle) < 0.785: # Right
			Input.action_press("move_right")
		elif abs(angle) > 2.355: # Left
			Input.action_press("move_left")
		elif angle < -0.785 and angle > -2.355: # Up
			Input.action_press("move_up")
		elif angle > 0.785 and angle < 2.355: # Down
			Input.action_press("move_down")

# Reset joystick to hidden state
func reset_joystick():
	joystick_active = false
	joystick_tex.visible=false
	Input.action_release("move_up")
	Input.action_release("move_down")
	Input.action_release("move_left")
	Input.action_release("move_right")	


func _on_shoot_icon_countdown_timeout():
	shoot_tex.visible=false
