extends Node

var ws:WebSocketUtils
var server_url:String
var rest_api_server_url:String
signal message_received(msg: String)
signal connection_disconnected
signal server_config_fetched

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
			rest_api_server_url = data.get("sketchy_multiplayer_tictactoe", {}).get("rest_api_server_url","")
			print("✅ Server URL from config:", server_url)
			emit_signal("server_config_fetched")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("server_config_fetched", get_waiting_games)
	fetch_server_config()
	

func initialise(player:String, game:String) -> void:
	ws = WebSocketUtils.new(player, game, server_url)
	ws.connect('connected',self.on_connected)
	ws.connect('connection_error', self.on_connection_error)
	ws.connect('disconnected',self.on_disconnected)
	ws.connect('message_received',self.on_message_received)
	ws.connect_to_server()

func _on_http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	print("Received API Response Status:\n%d,%d"%[result, response_code])
	if response_code == 200:
		var json = JSON.new()
		print("API Response Received\n%s"%[body.get_string_from_utf8()])
		var parsed = json.parse(body.get_string_from_utf8())
		if parsed == OK:
			print(json)
			return json
		else:
			print("Error in JSON Parsing")

func get_waiting_games():
	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_http_request_completed)
	print("API GET Request:\n%s/games/one_player"%[rest_api_server_url])
	http.request("%s/games/one_player"%[rest_api_server_url])
	

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
	
func send_server_text(msg:String):
	ws.send_text_message(msg)
	
func send_player_move(row:int, col:int):
	ws.send_move(row, col)
	
func get_player_id():
	return ws.player_name
func get_game_id():
	return ws.game_id
