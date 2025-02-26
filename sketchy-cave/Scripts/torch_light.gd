extends Node2D

@export var light:PointLight2D

@export var flicker_timer = 0.0

func _process(delta):
	flicker_timer += delta * 7.5  # Adjust speed of flicker

	# Create a smooth flickering effect
	var flicker_intensity = 0.75+sin(flicker_timer) * 0.1 + cos(flicker_timer * 0.8) * 0.1
	flicker_intensity += randf_range(0.0,0.05)  # Add randomness for more realism

	# Apply flicker to light energy
	light.energy = 1.0+ flicker_intensity  # Adjust energy dynamically

	# Slightly modify light scale (size pulsation effect)
	light.scale = Vector2(1.0, 1.0) * (1.0 + flicker_intensity * 0.2)

	# Slight random movement to simulate handheld torch swaying
	light.offset = Vector2(randf_range(-2, 2), randf_range(-2, 2))
