extends Node

@onready var main_screen_ui = $MainScreenUI
@onready var game_level = $GameLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_screen_ui.visible = true
	game_level.visible = false

func receive_main_signal(type:String, value:String):
	if type=='loaded_level':
		ProjectSettings.set_setting('current/level',value)
		main_screen_ui.visible = false
		game_level.visible = true
