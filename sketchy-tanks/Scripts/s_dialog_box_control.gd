extends CanvasLayer

@export var label:RichTextLabel
@export var button_1:Button
@export var button_2:Button

func set_dialog(label_text:String, button_1_text:String, button_2_text:String):
	label.text = label_text
	button_1.text = button_1_text
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
