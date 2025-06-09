class_name WebSocketUtils

signal connected
signal connection_error
signal disconnected
signal message_received(msg: String)

var player_name: String
var game_id: String
var server_url : String

var ws: WebSocketPeer
var is_connected := false

func _init(p_name: String, p_game_id: String, server:String):
	player_name = p_name
	game_id = p_game_id
	server_url = server

func get_full_server_url():
	return "%s/ws/%s/%s" % [server_url, game_id, player_name]

func connect_to_server():
	var full_url = get_full_server_url()
	ws = WebSocketPeer.new()
	var err = ws.connect_to_url(full_url)
	if err != OK:
		print("Failed to connect: ", err)
		emit_signal("connection_error")

func check_status():
	if ws == null:
		return

	ws.poll()

	var status = ws.get_ready_state()

	match status:
		WebSocketPeer.STATE_OPEN:
			if not is_connected:
				is_connected = true
				print("✅ WebSocket connected")
				emit_signal("connected")

			while ws.get_available_packet_count() > 0:
				var msg = ws.get_packet().get_string_from_utf8()
				_decode_server_message(msg)

		WebSocketPeer.STATE_CLOSING, WebSocketPeer.STATE_CLOSED:
			if is_connected:
				is_connected = false
				print("🔌 Disconnected from server")
				emit_signal("disconnected")

func send_text_message(msg: String):
	if is_connected and ws:
		ws.send_text(msg)

func send_move(row: int, col: int):
	send_text_message("MOVE|%d|%d" % [row, col])

func _decode_server_message(msg: String):
	emit_signal("message_received",msg)
	#var parts = msg.split("|")
	#var msg_type = parts[0]
	#var data = parts.slice(1)
	
static func generate_short_id(length := 8) -> String:
	const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var id := ""
	for i in length:
		id += chars[randi() % chars.length()]
	return id
