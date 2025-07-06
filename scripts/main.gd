extends Node

@export var asteroid_scene: PackedScene
@export var bomb_scene: PackedScene
@export var rocket_scene: PackedScene

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() # seed random nubmer generator

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		$Player.hide()
		$Player/CollisionShape2D.disabled = true
		$Player.speed = 0
		main_screen_transition()
	
func new_game():
	score = 0
	get_tree().call_group("asteroid_group", "queue_free")
	get_tree().call_group("bomb_group", "queue_free")
	get_tree().call_group("rockets", "queue_free")
	$HUD.update_score(score)
	$HUD.update_health($Player.health)
	$Player.start($StartPosition.position)
	$Player.visible = true
	$Player.health = $Player.max_health
	$AsteroidTimer.start()
	$BombTimer.start()
	$RocketTimer.start()
	
	
func main_screen_transition():
	# Stop timers
	$HUD.show_main()
	
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

func _on_rocket_timer_timeout() -> void:
	var rocket = preload("res://scenes/rocket.tscn").instantiate()
	var rocket_spawn_location = $AsteroidPath/AsteroidSpawnLocation
	rocket_spawn_location.progress_ratio = randf()
	rocket.position = rocket_spawn_location.position
	add_child(rocket)
