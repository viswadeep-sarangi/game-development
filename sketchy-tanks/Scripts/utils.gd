extends Node

class_name Utils

static var CONFIG_PATH = "user://game_settings.cfg"

static func get_config(section:String, key:String, default:String):
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	if err!=OK:
		print("ConfigFile doesn't exist. Returning default %s"%[default])
		return default
	else:
		return config.get_value(section, key, str(default))
		
static func set_config(section:String, key:String, value:Variant):
	var config = ConfigFile.new()
	config.set_value(section, key, value)
	config.save(CONFIG_PATH)
	print("Saved ConfigFile with section:",section,', key:',key,', value:',value)
	return true

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
	
