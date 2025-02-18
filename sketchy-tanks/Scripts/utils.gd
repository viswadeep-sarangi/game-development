extends Node

class_name Utils

static var CONFIG_PATH = "user://game_settings.cfg"
static var config:=ConfigFile.new()
static var is_config_loaded:=false
static var is_config_file_open=true

static func ensure_loaded():
	if not is_config_loaded and not is_config_file_open:
		is_config_file_open=true
		var err = config.load(CONFIG_PATH)
		if err != OK:
			is_config_loaded=false
			var err2 = config.save(CONFIG_PATH)
			if err2!=OK:
				push_error("Couldn't create empty config file")
			else:
				is_config_loaded=true
		else:
			is_config_loaded = true
	is_config_file_open=false
	return is_config_loaded

static func get_config(section:String, key:String, default:Variant):
	if ensure_loaded():
		return config.get_value(section, key, default)
	else:
		print("ConfigFile doesn't exist. Returning default %s"%[default])
		return default
		
static func set_config(section:String, key:String, value:Variant):
	if ensure_loaded():
		config.set_value(section, key, value)
		var err = config.save(CONFIG_PATH)
		if err!=OK:
			push_error("Couldn't save config")
			return false
		else:
			print("Saved ConfigFile with section:",section,', key:',key,', value:',value)
			return true
	else:
		print("Couldn't load config file")
		return false

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
	
