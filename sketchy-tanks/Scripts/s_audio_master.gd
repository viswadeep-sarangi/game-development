extends Node2D

@export_group("Audio Stream Players")
@export var background_player:AudioStreamPlayer2D
@export var level_sounds:AudioStreamPlayer2D
@export var ui_sounds:AudioStreamPlayer2D

@export_group("Player Variables")
@export var ui_background_music_db = -15
@export var level_background_music_db = -22
@export var level_sounds_db:float = -15
@export var ui_sounds_db:float = -15

@export_group("Background Music")
@export var ui_background_music:AudioStream
@export var level_1_3_background:AudioStream
@export var level_4_7_background:AudioStream
@export var level_8_10_background:AudioStream

@export_group("Level Sound Effects")
@export var bullet_fire:AudioStream
@export var bullet_hit:AudioStream
@export var enemy_tank_boom:AudioStream
@export var brick_boom:AudioStream
@export var player_hit:AudioStream
@export var player_tank_boom:AudioStream
@export var diamond_hit:AudioStream

@export_group("UI Sound Effects")
@export var button_click:AudioStream

func _ready():	
	level_sounds.volume_db = level_sounds_db
	ui_sounds.volume_db = ui_sounds_db
	
	background_player.stream = ui_background_music
	background_player.volume_db = ui_background_music_db
	background_player.play()

func receive_signal(value:String):
	if value=='diamond_hit':
		level_sounds.stream = diamond_hit
	if value=='enemy_died':
		level_sounds.stream = enemy_tank_boom
	if value=='brick_destroyed':
		level_sounds.stream = brick_boom
	if value=='player_hit':
		level_sounds.stream = player_hit
	level_sounds.play()

func receive_level_signal(a:String, b:String):
	if b=="Player Tank Destroyed":
		level_sounds.stream = player_tank_boom
	level_sounds.play()
	
func receive_main_signal(a:String, b:String):
	if a=='loaded_level':
		if background_player.playing:
			background_player.stop()
		if 1<=int(b) and int(b)<=3:
			background_player.stream = level_1_3_background
		if 4<=int(b) and int(b)<=6:
			background_player.stream = level_4_7_background
		if 7<=int(b) and int(b)<=10:
			background_player.stream = level_8_10_background
		print("AudioMaster>Playing %s level music"%[b])
	background_player.volume_db = level_background_music_db
	background_player.play()

func receive_game_level_signal(a:String, b:String):
	if a=='main_menu':
		background_player.stream = ui_background_music
		print("AudioMaster>Playing main menu background music")
	background_player.volume_db = ui_background_music_db
	background_player.play()

func _on_background_music_finished():
	background_player.play()
