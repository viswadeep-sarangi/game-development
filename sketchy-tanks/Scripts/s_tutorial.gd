extends Control

@export_group('Page Containers')
@export var page_container:MarginContainer
@export var page_1:MarginContainer
@export var page_2:MarginContainer
@export var page_3:MarginContainer

@export_group('Buttons')
@export var button_1:Button
@export var button_2:Button

@export_group('Variables')
@export var curr_page:int=1

# Called when the node enters the scene tree for the first time.
func _ready():
	curr_page=1
	page_container.visible = true
	activate_page(curr_page)
	

func activate_page(page_num:int):
	Utils.en_dis_able_node(page_container,false,false)
	if page_num==1:
		Utils.en_dis_able_node(page_1,true,true)
	if page_num==2:
		Utils.en_dis_able_node(page_2,true,true)
	if page_num==3:
		Utils.en_dis_able_node(page_3,true,true)
	
	button_1.text='Previous'
	button_2.text = 'Next'
	if page_num==1:
		button_1.disabled=true
	else:
		button_1.disabled=false
	if page_num==3:
		button_2.text='Done'
	
	curr_page=page_num


func _on_prev_button_pressed():
	activate_page(curr_page-1)


func _on_next_button_pressed():
	if curr_page!=3:
		activate_page(curr_page+1)
	else:
		queue_free()
