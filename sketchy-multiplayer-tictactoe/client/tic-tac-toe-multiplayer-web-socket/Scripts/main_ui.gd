extends Control
class_name MainUI


@onready var p_name:TextEdit = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/PlayerNameTextEdit
@onready var g_id:TextEdit = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/GameNameTextEdit
@onready var curr_games_vbox_cont: VBoxContainer = $Panel/VBoxContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer

@export var existing_game_button:PackedScene

signal create_game(player_name:String, game_id:String)
signal refresh_games

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p_name.text = "PLAYER_"+WebSocketUtils.generate_short_id(5)
	g_id.text = "GAME_"+WebSocketUtils.generate_short_id(5)

func _on_create_game_button_pressed() -> void:
	print("Creating Game with ",p_name.text,", ",g_id.text)
	emit_signal("create_game", p_name.text, g_id.text)

func _on_refresh_game_button_pressed():
	# removing all existing games currently
	for curr_game in curr_games_vbox_cont.get_children():
		remove_child(curr_game)
		curr_game.queue_free()
	emit_signal("refresh_games")

func populate_waiting_games(games:JSON):
	var all_games = games.data
	print("Received Waiting Games\n%s"%[JSON.stringify(games)])
	for game in all_games:
		print("Iteration: %s"%[JSON.stringify(game)])
		var existing_game_button_instance:ExistingGameButton = existing_game_button.instantiate()
		curr_games_vbox_cont.add_child(existing_game_button_instance)
		existing_game_button_instance.set_min_height()
		existing_game_button_instance.set_game_player(game['game_id'],game['player_id'])
		existing_game_button_instance.connect("join_game_pressed",self._on_join_game_button_pressed)
		

func _on_join_game_button_pressed(game_id:String, pressed_button:Button):
	for child in curr_games_vbox_cont.get_children():
		var butt:Button = child
		if butt!=pressed_button:
			butt.button_pressed = false
		else:
			butt.button_pressed=true
	g_id.text = game_id
