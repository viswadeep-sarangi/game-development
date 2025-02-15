extends Node2D

@onready var post_process_config:PostProcessingConfiguration = $PostProcess.configuration

@export var shake_time = 1
@export var shake_speed = 25
@export var shake_deviation = 5
@export var shake_decay = true

func _ready():
	pass
	#post_process_config.set('ScreenShakePower',0)
	#post_process_config.VignetteIntensity = 0
	#post_process_config.L_O_D = 0

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
