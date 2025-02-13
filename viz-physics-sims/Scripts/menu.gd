extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in $VBoxContainer.get_children():
		if child is Button:
			print("Found child button: ",child.text)
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
