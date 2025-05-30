extends MarginContainer
signal cell_clicked(r:int, c:int)
@export var row:int=0
@export var col:int=0
@onready var tex_but:TextureButton = $TextureButton

func set_row_col(r:int, c:int):
	row = r
	col = c

func _on_texture_button_pressed() -> void:
	print("Button Clicked (from inside) Emiting Signal for: ",row," ,",col)
	emit_signal("cell_clicked", row, col)
