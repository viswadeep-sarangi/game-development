# This is a comment in GDScript, and below is the correct usage of the `tool` keyword
@tool  # This makes the script run in the editor

extends ColorRect  # Adjust this line to match the type of your node

func _ready():
	if Engine.is_editor_hint():
		self.visible = false  # Hide the node in the editor
	else:
		self.visible = true  # Ensure the node is visible in the game
