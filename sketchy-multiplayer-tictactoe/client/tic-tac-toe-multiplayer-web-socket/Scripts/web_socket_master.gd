extends Node

var ws:WebSocketUtils
var server_url:= "wss://server-lingering-breeze-8312.fly.dev"
# Called when the node enters the scene tree for the first time.
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
func on_message_received(msg_type: String, data: Array):
	print("Msg Received- Type: ",msg_type, " , data: ",data)
