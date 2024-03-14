extends Node2D

@export var cam_move_speed: float = 1.0

var prog_ratio_list: Array = [0.0, 0.1029, 0.1755, 0.2202, 0.2593, 0.3319, 0.4157, 0.4939, 0.5777, 0.6783]
var curr_prog_ratio_pos = 0
var move_camera: bool = false
var camera_moving: bool = false
var t=0.0 # Time or progress, goes from 0 to 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		print("A key was just pressed down.")
		move_camera = true
	elif event is InputEventMouseButton and event.pressed:
		print("A mouse button was just pressed down.")
		move_camera = true
	elif event is InputEventJoypadButton and event.pressed:
		print("A gamepad button was just pressed down.")
		move_camera = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if move_camera and camera_moving:
		move_camera = false
	if move_camera and not camera_moving:
		curr_prog_ratio_pos = curr_prog_ratio_pos + 1
		if curr_prog_ratio_pos == len(prog_ratio_list):
			curr_prog_ratio_pos = 0
		camera_moving = true
		move_camera = false
	
	if camera_moving:
		t+= cam_move_speed*delta
		t = clamp(t,0.0,1.0)
		var smooth_t = smoothstep(0.0,1.0,t)
		
		$Path2D/PathFollow2D.progress_ratio = lerp(
			$Path2D/PathFollow2D.progress_ratio, 
			prog_ratio_list[curr_prog_ratio_pos],
			smooth_t
			)
		if is_equal_approx($Path2D/PathFollow2D.progress_ratio, prog_ratio_list[curr_prog_ratio_pos]):
			camera_moving = false
			t=0.0


func _on_visible_on_screen_enabler_2d_screen_entered():
	print("Entered") # Replace with function body.


func _on_visible_on_screen_enabler_2d_screen_exited():
	print("Exited") # Replace with function body.
