extends Node

var ws:WebSocketUtils
var server_url:String
signal message_received(msg: String)
signal connection_disconnected

func fetch_server_config():
	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_request_completed)
	var url = "https://viswadeep-sarangi.github.io/configs/game_development_configs.json"
	var err = http.request(url)
	if err != OK:
		print("HTTP Request failed: ", err)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if response_code == 200:
		var json_string = body.get_string_from_utf8()
		var json = JSON.new()
		var error = json.parse(json_string)

		if error == OK:
			var data = json.data
			print(data)
			server_url = data.get("sketchy_multiplayer_tictactoe", {}).get("websocket_server_url","")
			print("✅ Server URL from config:", server_url)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fetch_server_config()

func initialise(player:String, game:String) -> void:
	ws = WebSocketUtils.new(player, game, server_url)
	ws.connect('connected',self.on_connected)
	ws.connect('connection_error', self.on_connection_error)
	ws.connect('disconnected',self.on_disconnected)
	ws.connect('message_received',self.on_message_received)
	ws.connect_to_server()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if ws!=null:
		ws.check_status()
	
func on_connected():
	print("Connected!")
func on_connection_error():
	print("Connection Error :(")
func on_disconnected():
	print("Disconnected")
	emit_signal("connection_disconnected")
func on_message_received(msg: String):
	emit_signal("message_received", msg)
	
func send_player_move(row:int, col:int):
	ws.send_move(row, col)
