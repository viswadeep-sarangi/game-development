extends Node

class_name CameraUtils

static var original_positions = {}

static func shake_camera(camera: Camera2D, intensity: float, speed: float, duration: float = 0.5):
	if camera == null:
		push_error("Camera is null. Please pass a valid Camera2D.")
		return

	# Store the original position if not already stored
	if camera not in original_positions:
		original_positions[camera] = camera.position

	var shake_timer = duration
	var initial_intensity = intensity
	var initial_speed = speed

	var delta = 0.016  # Approximate frame time for 60 FPS

	while shake_timer > 0:
		shake_timer -= delta

		# Calculate decreasing intensity and speed
		var current_intensity = initial_intensity * (shake_timer / duration)
		var current_speed = initial_speed * (shake_timer / duration)

		# Apply shake using sine waves for smooth randomness
		var shake_offset = Vector2(
			sin(Time.get_unix_time_from_system() * current_speed) * current_intensity,
			cos(Time.get_unix_time_from_system() * current_speed) * current_intensity
		)
		camera.position = original_positions[camera] + shake_offset

		OS.delay_msec(int(delta * 1000))  # Run at ~60 FPS

	# Reset camera to original position
	camera.position = original_positions[camera]
	original_positions.erase(camera)
