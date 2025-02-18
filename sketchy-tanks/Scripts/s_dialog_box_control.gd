extends CanvasLayer

@export var label:RichTextLabel
@export var button_1:Button
@export var button_2:Button
@export var dialog_panel:PanelContainer
@export var button_container:MarginContainer
@export var button_countdown_timer:Timer

func set_dialog(
	label_text:String, 
	button_1_text:String, 
	button_2_text:String,
	mod_c:Color = Color(1,1,1),
	button_countdown:float=0.25
):
	#dialog_panel.modulate=Color(mod_c.r, mod_c.g, mod_c.b, 0.25)
	#var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	#tween.tween_property(dialog_panel,'modulate:a',1,timeout)
	dialog_panel.modulate = mod_c
	label.text = "[center]%s"%[label_text]
	if len(button_1_text)==0:
		button_1.visible=false
	else:
		button_1.visible=true
		button_1.text = button_1_text
	if len(button_2_text)==0:
		button_2.visible=false
	else:
		button_2.visible=true
		button_2.text=button_2_text
		
	button_container.visible=false
	button_countdown_timer.wait_time=button_countdown
	button_countdown_timer.stop()
	button_countdown_timer.start()

func _on_button_countdown_timer_timeout():
	button_container.visible=true

func _on_option_1_pressed():
	get_tree().call_group(
		"ui_signal_emitters", 
		"dialog_box_signal_received", 
		label.text, 
		button_1.text
	)


func _on_option_2_pressed():
	get_tree().call_group(
		"ui_signal_emitters", 
		"dialog_box_signal_received", 
		label.text, 
		button_2.text
	)
