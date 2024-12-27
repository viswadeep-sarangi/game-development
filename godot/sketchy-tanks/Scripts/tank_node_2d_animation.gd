extends Node2D

@onready var left_wheels = $"../track_left"
@onready var right_wheels = $"../track_right"

func update_velocity(velocity: Vector2, is_turning_direction:int):
	# Check if the tank is moving
	if velocity.length() > 0 or is_turning_direction!=0:
		play_animations()
	else:
		pause_animations()

func play_animations():
	# Play the "move" animation on both sprites
	if not left_wheels.is_playing():
		left_wheels.play("move")
	if not right_wheels.is_playing():
		right_wheels.play("move")

func pause_animations():
	# Pause the animations on both sprites
	left_wheels.stop()
	right_wheels.stop()
