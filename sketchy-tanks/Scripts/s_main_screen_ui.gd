extends Control

@export var playground_node_2d:PackedScene
@export var dialog_box_scene:PackedScene
@export var game_menu_margin:MarginContainer
@export var level_ui:CanvasItem
@export var first_level_uis:Array[MarginContainer]  # level menu margin
@export var tutorial_ui:PackedScene
var playground_child = null
var dialog_box:CanvasLayer = null

func en_dis_able_game_menu_ui(en_dis:bool):
	Utils.en_dis_able_node(game_menu_margin, en_dis, true)

func en_dis_able_levels_ui(en_dis:bool):
	Utils.en_dis_able_node(game_menu_margin, not en_dis, true)
	Utils.en_dis_able_node(level_ui, en_dis, true)

func hide_first_levels_vis_main_menu(firsts=false,main_menu=true):
	for ui in first_level_uis:
		Utils.en_dis_able_node(ui,firsts,true)
		#ui.visible=firsts
	Utils.en_dis_able_node(game_menu_margin,main_menu,true)
	#game_menu_margin.visible=main_menu
	
func en_dis_able_button_on_completed_levels():
	for i in range(2,11):
		var x=find_child("Level%dButton"%[i],true,true)
		if i==1:
			x.disabled=false
		elif not Utils.get_config('completed_levels',str(i-1),false):
			x.disabled=true
		else:
			x.disabled=false
	
func connect_button_pressed():
	for i in range(1,11):
		var x=find_child("Level%dButton"%[i],true,true)
		if x is Button:
			x.pressed.connect(_on_level_button_pressed.bind(i))
			# Enabling / Diabling Buttons
			

func _on_start_game_button_pressed() -> void:
	en_dis_able_levels_ui(true)
	get_tree().call_group(
		"ui_signal_emitters", 
		"receive_ui_signal", 
		"start_button_pressed", 
		""
	)
	var first_time = Utils.get_config('game','first_time',true)
	print("Got first time config: ",first_time)
	if first_time:		
		var tut = tutorial_ui.instantiate()
		add_child(tut)
		Utils.set_config('game','first_time',false)
		
	#$MainLayout/LevelMenuMargin.visible = true

func _on_exit_game_button_pressed() -> void:
	get_tree().quit()

func _on_back_button_pressed() -> void:
	en_dis_able_levels_ui(false)

func _on_level_button_pressed(level: int) -> void:
	print("Level Button Pressed: %d"%[level])
	get_tree().call_group(
		"ui_signal_emitters", 
		"receive_ui_signal", 
		"load_level", 
		str(level)
	)

func _ready() -> void:	
	en_dis_able_levels_ui(false)
	await get_tree().process_frame  # waiting for UI to be drawn
	connect_button_pressed()
	en_dis_able_button_on_completed_levels()


func _on_visibility_changed():
	en_dis_able_button_on_completed_levels()
	#if visible and playground_child==null:
		#playground_child = playground_node_2d.instantiate()
		#add_child(playground_child)
	#elif not visible and playground_child:
		#playground_child.queue_free()
		#playground_child = null
		
func dialog_box_signal_received(label:String, option:String):
	print("MainScreenUI > dialog_box_signal_received : ",label,' : ',option)
	if (
		label=='[center]Exit Level' and  option=='Yes'
	) or (
		label=="[center]Level Lost" and option=="Home"
	) or (
		label=="[center]Level Won" and option=="Home"
	):
		get_tree().call_group(
			"main_game_signal_emitters", 
			"main_game_signal_received", 
			"exit_level", 
			""
		)
	destroy_dialog_box()

func create_dialog_box(label:String, button1:String, button2:String, mod_c:Color=Color(1,1,1), countdown:float=0.01):
	dialog_box = dialog_box_scene.instantiate()
	add_child(dialog_box)
	get_tree().paused=true
	dialog_box.set_dialog(label, button1, button2, mod_c, countdown)	
	
func destroy_dialog_box():
	if dialog_box:
		dialog_box.queue_free()
		dialog_box=null
	get_tree().paused=false

func receive_level_signal(type:String, value:String):
	print("MainScreenUI > Received Signal ",type,' : ',value)
	if type=='back_button':
		create_dialog_box("Exit Level", "Yes", "No")
	elif type=='level_lost':
		create_dialog_box("Level Lost", "", "Home",Color(1,0.5,0.5),1)
	elif type=='level_won':
		create_dialog_box("Level Won", "", "Home",Color(0.5,1,0.5),1)
		


func _on_tutorial_button_pressed():
	var tut = tutorial_ui.instantiate()
	add_child(tut)
