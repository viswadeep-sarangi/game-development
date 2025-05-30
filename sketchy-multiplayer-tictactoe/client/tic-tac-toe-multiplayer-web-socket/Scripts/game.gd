extends Control

@export var margin_cont_button:PackedScene
@onready var tictactoe_grid = $Panel/AspectRatioContainer/ColorRect/GridContainer

var grid_button_map = {}
signal grid_cell_clicked(row:int, col:int)

func populate_grids():
	for x in range(9):
		var grid_button = margin_cont_button.instantiate()
		grid_button.set_row_col(floor(x/3),x%3)
		grid_button.connect("cell_clicked", self._on_grid_cell_clicked)
		grid_button_map[[floor(x/3),x%3]] = grid_button
		tictactoe_grid.add_child(grid_button)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_grids()

func _on_grid_cell_clicked(row:int, col:int):
	print("Signal Caught For Cell: ",row," ,",col)
