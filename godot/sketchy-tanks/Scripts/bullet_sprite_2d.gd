extends RigidBody2D
@export var bullet_speed: float = 500.0 
@export var implosion_anim:PackedScene
@onready var bullet_sprite:Sprite2D = $BulletSprite2D
@onready var collision_shape:CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity = Vector2.RIGHT.rotated(rotation) * bullet_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not get_viewport_rect().has_point(global_position):
		queue_free()
		
func modulate_bullet_color(c:Color):
	var sprite = $BulletSprite2D
	sprite.modulate = c

func _on_body_entered(body: Node) -> void:
	var boom:Node = implosion_anim.instantiate()
	boom.global_position = global_position
	get_parent().add_child(boom)
	queue_free()
