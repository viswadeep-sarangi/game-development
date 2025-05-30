extends Node2D

@onready var ui = $UI
@onready var game = $Game
@onready var websocketmaster = $WebSocketMaster

@export var main_ui_scene:PackedScene
@export var game_scene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var main_ui_instance = main_ui_scene.instantiate()
	ui.add_child(main_ui_instance)
	main_ui_instance.connect("create_game", self._on_create_game)

func _on_create_game(player_name:String, game_id:String):
	websocketmaster.initialise(player_name, game_id)
	ui.visible = false
	var game_instance = game_scene.instantiate()
	game.add_child(game_instance)
