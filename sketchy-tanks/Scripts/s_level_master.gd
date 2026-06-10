extends Node2D

var enemies = null
@export var num_enemies:int
var diamonds
@export var num_diamonds:int
@export var level_num:int = 1
@export var nav_master:Node2D
@onready var touch_controls_scene=preload("res://Prefabs/touch_screen_control.tscn")
func set_wall_positions():
	var bg:Sprite2D = get_parent().get_node("BG")
	for w in ['Left','Right','Top','Bottom']:
		var wall:Node2D = nav_master.get_node('NavigationRegion2D/Walls/%s'%[w])
		if w=='Left':
			wall.global_position = Vector2(0,wall.global_position.y)
		elif w=='Right':
			wall.global_position = Vector2(bg.get_rect().size.x,wall.global_position.y)
		elif w=='Top':
			wall.global_position = Vector2(wall.global_position.x,0)
		elif w=='Bottom':
			wall.global_position = Vector2(wall.global_position.x,bg.get_rect().size.y)
		

func _ready() -> void:
	await get_tree().process_frame
	enemies = get_tree().get_nodes_in_group('enemies')
	num_enemies = len(enemies)
	diamonds = get_tree().get_nodes_in_group('diamond')
	num_diamonds = len(diamonds)
	set_wall_positions()
	if DisplayServer.is_touchscreen_available():
		print("Touchscreen detected. Instantiating touch controls.")
		var touch_controls = touch_controls_scene.instantiate()
		get_parent().add_child(touch_controls)

var receive_signal_in_progress = false
func receive_signal(value):
	if receive_signal_in_progress:
		return
	receive_signal_in_progress = true
	if value=='enemy_died':
		num_enemies-=1
	if value=='diamond_hit':
		num_diamonds-=1
	
	if num_diamonds==0:
		get_tree().call_group(
			"level_signals", 
			"receive_level_signal", 
			"level_lost",
			str(level_num)
		)
		print("LEVEL LOST")
	elif num_enemies==0:
		get_tree().call_group(
			"level_signals", 
			"receive_level_signal", 
			"level_won",
			str(level_num)
		)
		print("LEVEL WON!!")
	receive_signal_in_progress = false


func _on_back_button_pressed():
	get_tree().call_group(
		"level_signals", 
		"receive_level_signal", 
		"back_button",
		str(level_num)
	)
