extends CanvasLayer

@export var label:RichTextLabel
@export var button_1:Button
@export var button_2:Button
@export var dialog_panel:PanelContainer

func set_dialog(
	label_text:String, 
	button_1_text:String, 
	button_2_text:String,
	timeout:float=0.0,
	mod_c:Color = Color(1,1,1,1)
):
	#dialog_panel.modulate=Color(mod_c.r, mod_c.g, mod_c.b, 0.25)
	#var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	#tween.tween_property(dialog_panel,'modulate:a',1,timeout)
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
