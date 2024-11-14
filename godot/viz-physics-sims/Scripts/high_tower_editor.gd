@tool
extends EditorScript

# Path to the scene you want to replicate
#const BLOCK_PATH := "res://Prefabs/circle_rigid_body_2d.tscn"
const BLOCK_PATH := "res://Prefabs/hex_rigid_body_2d.tscn"
const TOWER_PATH := "TowerNode2D"
const SPACING := 10

# Number of rows and columns in the grid
const GRID_ROWS := 100
const GRID_COLS := 5

#func _run():
	#print(get_scene().get_node('./TowerNode2D'))

func _run():
	
	var root_node = get_scene()
	if not root_node:
		print("No scene is currently open.")
		return
	var tower_node = root_node.get_node(TOWER_PATH)
	
	var block_prefab = load(BLOCK_PATH)
	var temp_block = block_prefab.instantiate()
	var block_width = temp_block.get_node('Sprite2D').get_rect().size.x/8
	var block_height = temp_block.get_node('Sprite2D').get_rect().size.x/8
	temp_block.queue_free()
	
	for row in range(GRID_ROWS):
		for col in range(GRID_COLS):
			var block = block_prefab.instantiate()
			block.position = Vector2(col*(block_width+SPACING), -1*row*(block_height+SPACING))
			#block.position = Vector2(col*block_width, row*block_height)
			tower_node.add_child(block)
			block.owner = root_node
			#root_node.set_scene_modified()
	#get_editor_interface().get_scene_tree_dock().refresh()
