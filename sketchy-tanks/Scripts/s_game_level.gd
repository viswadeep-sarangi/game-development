extends Node2D

func receive_ui_signal(task:String, value:String):
	if task=='load_level':
		var level_scene = load("res://Scenes/level_%s.tscn"%[value])
		var level = level_scene.instantiate()
		get_tree().call_group("main_game_signal_emitters", "receive_main_signal", "loaded_level", value)
		add_child(level)
