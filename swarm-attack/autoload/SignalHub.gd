extends Node

# Game state signals
signal game_started
signal game_paused
signal game_resumed
signal game_over
signal level_started(level: int)
signal level_completed
signal wave_started(wave: int)

# Player signals
signal player_swarm_spawned(swarm: Node2D)
signal player_unit_spawned(unit: Node2D)
signal player_unit_died(unit: Node2D)
signal player_swarm_health_changed(health: float, max_health: float)

# Enemy signals
signal enemy_swarm_spawned(swarm: Node2D, wave: int)
signal enemy_unit_spawned(unit: Node2D)
signal enemy_unit_died(unit: Node2D)
signal enemy_swarm_eliminated(swarm: Node2D)

# Combat signals
signal collision_detected(unit1: Node2D, unit2: Node2D)
signal unit_attacked(attacker: Node2D, target: Node2D, damage: float)

# Input signals
signal mouse_position_updated(position: Vector2)

# Debug signals
signal debug_message(message: String)
