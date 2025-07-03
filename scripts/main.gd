extends Node
@export var asteroid_scene: PackedScene
@export var bomb_scene: PackedScene
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		$Player.hide()
		$Player/CollisionShape2D.disabled = true
		$Player.speed = 0
		#game_over()
		main_screen_transition()
	
func new_game():
	score = 0
	$HUD.update_score(score)
	$Player.health = $Player.max_health
	$HUD.update_health($Player.health)
	$Player.start($StartPosition.position)
	$AsteroidTimer.start()
	$BombTimer.start()
	$Player.visible = true
	
func main_screen_transition():
	# Stop timers and enemy spawning
	$HUD.show_main()
	$AsteroidTimer.stop()
	$BombTimer.stop()
	get_tree().call_group("asteroid_group", "queue_free")
	get_tree().call_group("bomb_group", "queue_free")
	
func game_over():
	$HUD.show_game_over()
	main_screen_transition()
	
	
func _on_asteroid_timer_timeout() -> void:
	var asteroid = asteroid_scene.instantiate()

	var asteroid_spawn_location = $AsteroidPath/AsteroidSpawnLocation
	asteroid_spawn_location.progress_ratio = randf()
	
	asteroid.position = asteroid_spawn_location.position
	
	add_child(asteroid)
	
func update_score_from_asteroid() -> void:
	score+=1
	$HUD.update_score(score)


func _on_bomb_timer_timeout() -> void:
	var bomb = bomb_scene.instantiate()

	var bomb_spawn_location = $AsteroidPath/AsteroidSpawnLocation
	bomb_spawn_location.progress_ratio = randf()
	
	bomb.position = bomb_spawn_location.position
	
	add_child(bomb)
