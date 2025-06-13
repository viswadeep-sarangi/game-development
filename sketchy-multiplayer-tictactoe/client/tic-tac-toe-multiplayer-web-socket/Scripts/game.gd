extends Control

@export var margin_cont_button:PackedScene
@export var x_tex:Texture2D
@export var o_tex:Texture2D
@export var msg_box:PackedScene
@onready var tictactoe_grid = $Panel/AspectRatioContainer/ColorRect/GridContainer
@onready var game_panel:Panel = $Panel

var board:Array
var grid_button_array:Array
signal grid_cell_clicked(row:int, col:int)
signal game_win(player_id:String)
signal game_draw
signal game_finished

func populate_grids():
	grid_button_array=[]
	for r in range(3):
		var x =[]
		for c in range(3):
			var grid_button = margin_cont_button.instantiate()
			grid_button.set_row_col(r,c)
			grid_button.connect("cell_clicked", self._on_grid_cell_clicked)
			x.append(grid_button)
			tictactoe_grid.add_child(grid_button)
		grid_button_array.append(x)

func refresh_board():
	board=[]
	for x in range(3):
		var a=[]
		for y in range(3):
			a.append("")
		board.append(a)
	print("Board refreshed")
	print(board)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_grids()
	refresh_board()

func _on_grid_cell_clicked(row:int, col:int):
	print("Signal Caught For Cell: ",row," ,",col)
	if board[row][col]=="":
		emit_signal("grid_cell_clicked", row, col)
	else:
		print("Cell already taken: ",board[row][col])
	
func _on_server_receive_msg(msg:String):
	print("RECEIVED FROM SERVER: ",msg)
	var parts = msg.split("|")
	var msg_type = parts[0]
	var data = parts.slice(1)
	print("Msg Type: %s, Data: %s"%[msg_type, data])
	match msg_type:
		"UPDATE":
			var row=int(data[0])
			var col=int(data[1])
			var symbol:String=data[2]
			print("Updating %d, %d with %s"%[row,col,symbol])
			var x:TextureButton = grid_button_array[row][col].get_node("TextureButton")
			if symbol.to_lower()=="x":
				x.texture_normal=x_tex
			elif symbol.to_lower()=="o":
				x.texture_normal=o_tex
		"WIN":
			emit_signal("game_win", data[0])
			var x = msg_box.instantiate()
			game_panel.add_child(x)
			x.create_msgbox("Game Win", "FINISH GAME")
			x.connect("msgbox_button_clicked", self._on_msgbox_button_clicked)
		"DRAW":
			emit_signal("game_draw")
			
func _on_msgbox_button_clicked(button_msg:String):
	match button_msg:
		"FINISH GAME":
			emit_signal("game_finished")
			queue_free()
