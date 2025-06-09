extends Control

@export var button_margin_prefab:PackedScene
@onready var button_container = $MSGBox/ColorRect/MSGVBox/ButtonHBoxContainer
@onready var msg_label = $MSGBox/ColorRect/MSGVBox/MsgLabel

func create_msgbox(msg:String, button_msgs:String):
	msg_label.text = msg
	var msgs_arr = button_msgs.split(",")
	for x in range(msgs_arr.size()):
		var butt_inst = button_margin_prefab.instantiate()
		var butt:Button = butt_inst.find_child("Button")
		butt.text = msgs_arr[x]
			
