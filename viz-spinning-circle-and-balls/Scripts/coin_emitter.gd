extends Node2D
# Inside the child scene script
@onready var coin_emitter:Node2D = $EmitterNode2D
@onready var coin_prefab = preload('res://Scenes/coin.tscn')
var speed:float = 500.0
var direction: Vector2 = Vector2(1.0,0.0)
var screen_left_x:int
var screen_right_x:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_size = get_viewport_rect().size
	var half_screen_size = screen_size /2
	screen_left_x = -1*half_screen_size.x
	screen_right_x = half_screen_size.x
	$Timer.start()

func frame_update(delta:float):
	coin_emitter.position = coin_emitter.position + direction*speed*delta
	#printt("Emitter Position: ",coin_emitter.position, "Direction:",direction, "Speed",speed, "Change:",direction*speed*delta)
	if coin_emitter.position.x > screen_right_x:
		direction = Vector2(-1,0)
	if coin_emitter.position.x < screen_left_x:
		direction = Vector2(1,0)

func _process(delta: float) -> void:
	frame_update(delta)


func _on_timer_timeout() -> void:
	var coin_instance = coin_prefab.instantiate()
	coin_instance.position = coin_emitter.position
	add_child(coin_instance)
	var curr_wait_time = $Timer.wait_time
	$Timer.wait_time = lerpf(curr_wait_time, 0.0001, 0.5)
