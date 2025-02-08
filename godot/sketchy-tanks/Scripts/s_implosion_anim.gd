extends Node

@onready var boom_anim:AnimatedSprite2D = $BoomAnim
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boom_anim.stop()
	boom_anim.play()

func _on_boom_anim_animation_finished() -> void:
	queue_free()
