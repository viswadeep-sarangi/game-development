extends Node2D

@export var enemy_scene: PackedScene
@export var player_swarm: PlayerSwarm
@export var enemy_container: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_enemy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn_enemy():
	var enemy := enemy_scene.instantiate() as EnemySwarm
	enemy_container.add_child(enemy)
	var screen_size := get_viewport_rect().size

	enemy.global_position = Vector2(
		randf_range(0.0, screen_size.x),
		randf_range(0.0, screen_size.y)
	)
	enemy.setup(player_swarm)
