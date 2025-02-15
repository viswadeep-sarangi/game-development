extends Node2D

var level = null

func receive_ui_signal(task:String, value:String):
	if task=='load_level':
		var level_scene = load("res://Scenes/level_%s.tscn"%[value])
		level = level_scene.instantiate()
		get_tree().call_group("main_game_signal_emitters", "receive_main_signal", "loaded_level", value)
		add_child(level)
		
func main_game_signal_received(task:String, value:String):
	print("GameLevel>main_game_signal_received: ",task,' : ',value)
	if task=='exit_level':
		level.queue_free()
		for n in get_tree().get_nodes_in_group('bullets'):
			n.queue_free()
		level=null
		get_tree().call_group(
			"level_signals", 
			"receive_game_level_signal", 
			"main_menu", 
			""
		)
