extends Node2D

@onready var post_process_config:PostProcessingConfiguration = $PostProcess.configuration

@export var shake_time = 1
@export var shake_speed = 25
@export var shake_deviation = 5
@export var shake_decay = true

var cam:Camera2D
var bg:Sprite2D

func fit_to_contents(_padding:int=0):
	var viewport_size = get_viewport_rect().size
	var _width = bg.get_rect().size.x
	var _height = bg.get_rect().size.y
	var zoom_x = viewport_size.x / _width
	var zoom_y = viewport_size.y / _height
	cam.zoom = Vector2(min(zoom_x, zoom_y), min(zoom_x, zoom_y))  # Maintain aspect ratio
	cam.global_position = Vector2(_width / 2, _height / 2)  # Center camera

func _ready():
	await get_tree().process_frame
	bg = get_parent().get_node("BG")
	cam = get_node("Camera2D")
	fit_to_contents()

func vignette_pulse():
	var tween = get_tree().create_tween()	
	tween.tween_property(post_process_config, "VignetteIntensity", 0.25, 0.12)
	tween.tween_property(post_process_config, "VignetteIntensity", 0.0, 0.12)
	
func blur_fade_in():
	print("Blurring In")
	var tween = get_tree().create_tween()
	tween.tween_property(post_process_config, "L_O_D", 3.0, 2.0)
	tween.tween_property(post_process_config, "L_O_D", 0.0, 0.001)
	
func screen_shake():
	#post_process_config.set('ScreenShake',true)
	#post_process_config.set('ScreenShakePower',2)
	var tween = get_tree().create_tween()
	tween.tween_property(post_process_config, "ScreenShakePower", 0.75, 0.01)
	tween.tween_property(post_process_config, "ScreenShakePower", 0, 0.25)
	#post_process_config.set('ScreenShake',false)
	

var receive_signal_in_progress = false
func receive_signal(value):
	if receive_signal_in_progress:
		return
	if value=='enemy_died':
		screen_shake()
		#cam_control.shake(shake_time,shake_speed,shake_deviation,shake_decay)
	if value=='player_hit':
		vignette_pulse()
	if value=='diamond_hit':
		pass
		#blur_fade_in()
	receive_signal_in_progress=false
