extends Node2D

var enemies = null
var diamonds = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	diamonds = get_tree().get_nodes_in_group('diamond')
	if len(diamonds)==0:
		print("YOU LOST")
	
	enemies = get_tree().get_nodes_in_group('enemies')
	if len(enemies)==0:
		print("ALL ENEMIES DEFEATED. YOU'VE WON")
