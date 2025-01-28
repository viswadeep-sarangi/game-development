extends RigidBody2D
@export var bullet_speed: float = 500.0 

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
