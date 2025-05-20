extends Node2D
@export var asteroid_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func new_game():
	$Player.start($StartPosition.position)

func _on_asteroid_timer_timeout() -> void:
	var asteroid = asteroid_scene.instantiate()

	var asteroid_spawn_location = $AsteroidPath/AsteroidSpawnLocation
	asteroid_spawn_location.progress_ratio = randf()
	
	asteroid.position = asteroid_spawn_location.position
	
	add_child(asteroid)
