extends Node2D

var enemies = null
@export var num_enemies:int
var diamonds
@export var num_diamonds:int
@export var level_num:int = 1

func _ready() -> void:
	enemies = get_tree().get_nodes_in_group('enemies')
	num_enemies = len(enemies)
	diamonds = get_tree().get_nodes_in_group('diamond')
	num_diamonds = len(diamonds)

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
