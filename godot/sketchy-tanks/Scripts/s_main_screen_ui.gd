extends Control

#@onready var tank_anim:CharacterBody2D = $MainLayout/GameMenuMargin/GameMenu/Animation/TankNode2D
@onready var anim_panel:PanelContainer = $MainLayout/GameMenuMargin/GameMenu/Animation
@onready var game_menu_margin = $MainLayout/GameMenuMargin
@onready var first_level_uis = [
		$MainLayout/LevelMenuMargin
	]

func hide_first_levels_vis_main_menu(firsts=false,main_menu=true):
	for ui in first_level_uis:
		ui.visible=firsts
	game_menu_margin.visible=main_menu
	
func connect_button_pressed():
	for i in range(1,11):
		var x=find_child("Level%dButton"%[i],true,true)
		if x is Button:
			x.pressed.connect(_on_level_button_pressed.bind(i))

func _on_start_game_button_pressed() -> void:
	hide_first_levels_vis_main_menu(false,false)
	$MainLayout/LevelMenuMargin.visible = true

func _on_exit_game_button_pressed() -> void:
	get_tree().quit()

func _on_back_button_pressed() -> void:
	hide_first_levels_vis_main_menu()

func _on_level_button_pressed(level: int) -> void:
	print("Level Button Pressed: %d"%[level])
	get_tree().call_group("ui_signal_emitters", "receive_ui_signal", "load_level", str(level))

func _ready() -> void:
	hide_first_levels_vis_main_menu()
	connect_button_pressed()
	await get_tree().process_frame  # waiting for UI to be drawn
	var panel_global_rect = anim_panel.get_global_rect()
	var panel_center = panel_global_rect.get_center()
	#tank_anim.global_position = panel_centers
