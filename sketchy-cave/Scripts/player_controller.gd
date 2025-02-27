extends CharacterBody2D

class_name PlayerController

@export var speed:float = 200.0

var direction:=Vector2.ZERO

func call_player_group_movement_signal(direction:Vector2):
	get_tree().call_group(
		'>>>game_play_level_player',
		'_receive_movement_signal__game_play_level_player',
		direction
	)

func handle_keyboard_input() -> void:
	direction = Vector2.ZERO
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction.y += 1
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		call_player_group_movement_signal(direction)

func _process(delta):
	handle_keyboard_input()
	
func _receive_movement_signal__game_play_level_player(direction:Vector2):	
	velocity = direction * speed  # Set velocity based on input
	move_and_slide()  # Move the character
