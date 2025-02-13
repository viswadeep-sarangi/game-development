extends StaticBody2D

@export var explosion_anim:PackedScene
@export var health:int = 1

func hit(hit_point:int):
	health-=hit_point
	if health<=0:
		print(name+' has been hit and is now dead')
		var boom:Node2D = explosion_anim.instantiate()
		boom.global_position = global_position
		get_parent().add_child(boom)
		queue_free()
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
