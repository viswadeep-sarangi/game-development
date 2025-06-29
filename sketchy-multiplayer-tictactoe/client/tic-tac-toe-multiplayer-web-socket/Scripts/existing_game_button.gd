extends Button
class_name ExistingGameButton

var game_id:String
var curr_player_id:String
signal join_game_pressed(game_id:String, pressed_button:Button)
@onready var label:RichTextLabel = $RichTextLabel

func set_game_player(g_id:String, p_id:String, font_size:int=20):
	game_id = g_id
	curr_player_id = p_id
	#var butt_font_size:int = get_theme_font("font").size
	#label.push_font_size(butt_font_size)
	#var sub_font_size:int = int((butt_font_size*3)/4)
	#label.text = "[center]%s\n[color=grey][font_size=%d]%s is waiting...[/font_size][/color]"%[game_id,sub_font_size,curr_player_id]
	label.text = "[font_size=%d][color=#008B8B][center]%s"%[font_size, game_id]

func _on_pressed():
	emit_signal("join_game_pressed", game_id, self)
	
	
func set_min_height(h:int=75):
	custom_minimum_size=Vector2(size.x, h)
