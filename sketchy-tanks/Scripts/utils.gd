extends Node

class_name Utils

static func get_all_children(node: Node) -> Array:
	var children = []
	for child in node.get_children():
		children.append(child)
		children.append_array(get_all_children(child))  # Recursive call
	return children

static func en_dis_able_node(node:CanvasItem, en_dis:bool, inc_node:bool=true):
	for n in get_all_children(node):
		if n is CanvasItem:
			n.visible = en_dis
		if n is CollisionShape2D:
			n.disabled = not en_dis
	if inc_node:
		node.visible = en_dis
	
