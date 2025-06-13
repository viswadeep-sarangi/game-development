extends Control

@export var button_margin_prefab:PackedScene
@onready var button_container = $MSGBox/ColorRect/MSGVBox/ButtonHBoxContainer
@onready var msg_label:RichTextLabel = $MSGBox/ColorRect/MSGVBox/MsgLabel

signal msgbox_button_clicked(butt_msg:String)

func button_clicked(button_msg:String):
	print("MsgBox: Button Clicked: %s"%[button_msg])
	emit_signal("msgbox_button_clicked",button_msg)
	call_deferred("queue_free")

func create_msgbox(msg:String, button_msgs:String):
	msg_label.text = "[center]%s"%[msg]
	var msgs_arr = button_msgs.split(",")
	print("MsgBox: Creating  ",msgs_arr.size(), " buttons: ", msgs_arr)
	for x in range(msgs_arr.size()):
		var butt_inst = button_margin_prefab.instantiate()
		var butt:Button = butt_inst.find_child("Button")
		butt.text = msgs_arr[x]
		butt.connect("pressed", Callable(self, "button_clicked").bind(msgs_arr[x]))
		button_container.add_child(butt_inst)
