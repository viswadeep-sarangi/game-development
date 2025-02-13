extends Node

@onready var main_screen_ui = $MainScreenUI
@onready var game_level = $GameLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#main_screen_ui.hide_first_levels_vis_main_menu(true,true)
	main_screen_ui.en_dis_able_levels_ui(false)
	#main_screen_ui.visible = true
	Utils.en_dis_able_node(game_level, false)
	#game_level.visible = false
	await get_tree().process_frame  # waiting for UI to be drawn

func receive_main_signal(type:String, value:String):
	if type=='loaded_level':
		ProjectSettings.set_setting('current/level',value)
		main_screen_ui.en_dis_able_levels_ui(false)
		main_screen_ui.en_dis_able_game_menu_ui(false)
		main_screen_ui.visible=false
		Utils.en_dis_able_node(game_level, true)
		#main_screen_ui.visible = false
		#game_level.visible = true
		
func receive_game_level_signal(task:String, value:String):
	print("MainScreenUI>receive_game_level_signal:",task,':',value)
	if task=='main_menu':
		main_screen_ui.visible=true
		main_screen_ui.en_dis_able_levels_ui(false)
		#main_screen_ui.hide_first_levels_vis_main_menu(false,true)
		Utils.en_dis_able_node(game_level, false)
