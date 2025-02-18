extends RigidBody2D
# Preload the audio stream
var audio_stream = preload("res://Assets/Audio/glass-clinking-cropped.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.stream = audio_stream

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(_body: Node) -> void:
	$AudioStreamPlayer2D.play()
