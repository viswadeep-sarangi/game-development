extends Node2D
class_name Main

@onready var ui = $UI
@onready var game = $Game
@onready var websocketmaster:WebsockerMaster = $WebSocketMaster

@export var main_ui_scene:PackedScene
@export var game_scene:PackedScene
var game_instance:Node
var main_ui_instance:MainUI


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_ui_instance = main_ui_scene.instantiate()
	ui.add_child(main_ui_instance)
	main_ui_instance.connect("create_game", self._on_create_game)
	main_ui_instance.connect("refresh_games", self._on_refresh_games)
	websocketmaster.connect("waiting_games_fetched", self._on_waiting_games_fetched)

func _on_waiting_games_fetched(games:String):
	var json = JSON.new()
	var parsed = json.parse(games)
	if parsed == OK:
		main_ui_instance.populate_waiting_games(json)
	else:
		print("ERROR Fetching Waiting Games")

func _on_refresh_games():
	websocketmaster.get_waiting_games()

func _on_create_game(player_name:String, game_id:String):
	if game_instance!=null:
		game_instance.queue_free()
	
	websocketmaster.initialise(player_name, game_id)
	#ui.visible = false
	game_instance = game_scene.instantiate()
	game_instance.connect("grid_cell_clicked", websocketmaster.send_player_move)
	game_instance.connect("game_finished",self._on_game_finished)
	websocketmaster.connect("message_received", game_instance._on_server_receive_msg)
	game_instance.player_id = websocketmaster.get_player_id()
	game_instance.game_id = websocketmaster.get_game_id()
	game.add_child(game_instance)

func _on_game_finished():
	websocketmaster.disconnect("message_received", game_instance._on_server_receive_msg)
	websocketmaster.send_server_text("GAME_FINISHED")
	if game_instance!=null:
		game_instance.queue_free()
	ui.visible = true
