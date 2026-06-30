extends Node

# Game constants
const GAME_NAME = "Swarm Attack"
const GAME_VERSION = "0.1.0"

# Screen/Physics
const SCREEN_MARGIN = 50.0

# Swarm behaviour
const ROTATION_SPEED = 64.0
const MAX_FORCE = 1000.0
const SEPARATION = 10.0
const COHESION = 1.0
const ALIGNMENT = 1.0

# Player swarm
const PLAYER_UNIT_SPEED = 1000.0
const PLAYER_UNIT_SIZE = 10.0
const PLAYER_UNIT_COLOR = Color.CYAN
const PLAYER_UNIT_HEALTH = 10.0
const PLAYER_SWARM_MAX_UNITS = 100
const PLAYER_UNIT_SEPARATION_RADIUS = 20.0
const PLAYER_UNIT_COHESION_RADIUS = 100.0
const PLAYER_UNIT_ALIGNMENT_RADIUS = 100.0

# Enemy swarm
const ENEMY_UNIT_SPEED = 150.0
const ENEMY_UNIT_SIZE = 10.0
const ENEMY_UNIT_COLOR = Color.RED
const ENEMY_UNIT_HEALTH = 5.0
const ENEMY_SPAWN_OFFSET_FROM_SCREEN = 100.0

# Combat
const ATTACK_DAMAGE = 1.0
const ATTACK_RANGE = 30.0
const ATTACK_COOLDOWN = 0.5

# Level/Waves
const STARTING_LEVEL = 1
const WAVES_PER_LEVEL = 3
const ENEMY_SPAWN_INTERVAL = 2.0

# Wave configurations
const WAVE_CONFIGS = {
	1: [
		{"enemy_count": 10, "delay": 0.0},
		{"enemy_count": 15, "delay": 5.0},
		{"enemy_count": 20, "delay": 10.0}
	],
	2: [
		{"enemy_count": 20, "delay": 0.0},
		{"enemy_count": 25, "delay": 5.0},
		{"enemy_count": 30, "delay": 10.0}
	]
}
