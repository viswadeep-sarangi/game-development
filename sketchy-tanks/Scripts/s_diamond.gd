extends Node2D

@export var explosion_anim:PackedScene
@export var health:int = 1
@export var diamond_type:String=''
# Called when the node enters the scene tree for the first time.
func hit(hit_point:int):
	health-=hit_point
	if health<=0:
		print(name+' has been hit and is now dead')
		var boom:Node2D = explosion_anim.instantiate()
		boom.global_position = global_position
		get_parent().add_child(boom)
		get_tree().call_group(
			"signal_emitters", 
			"receive_signal", 
			"%sdiamond_hit"%[diamond_type]
		)
		queue_free()
