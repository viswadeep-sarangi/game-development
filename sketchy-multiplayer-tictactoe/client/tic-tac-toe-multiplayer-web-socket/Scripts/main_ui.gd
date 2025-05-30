extends Control

@onready var p_name:TextEdit = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/PlayerNameTextEdit
@onready var g_id:TextEdit = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/GameNameTextEdit

signal create_game(player_name:String, game_id:String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p_name.text = "PLAYER_"+WebSocketUtils.generate_short_id(5)
	g_id.text = "GAME_"+WebSocketUtils.generate_short_id(5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_create_game_button_pressed() -> void:
	print("Creating Game with ",p_name.text,", ",g_id.text)
	emit_signal("create_game", p_name.text, g_id.text)
