extends Node2D

@export var FORWARD_IMPULSE = 1000
@export var UPWARD_IMPULSE = -500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ProjectileRigidBody2D.apply_impulse(
		Vector2(FORWARD_IMPULSE,UPWARD_IMPULSE)
	)
	print("From high_tower GDScript")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
