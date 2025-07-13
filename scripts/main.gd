extends Node

@export var asteroid_scene: PackedScene
@export var bomb_scene: PackedScene
@export var rocket_scene: PackedScene
@export var upgrade_scene: PackedScene

@export var spawn_table: Array[Dictionary] = [
	{ scene = preload("res://scenes/asteroid.tscn"),  cooldown = 1.2, group = "asteroid_group" },
	{ scene = preload("res://scenes/bomb.tscn"),      cooldown = 3.5, group = "bomb_group" },
	{ scene = preload("res://scenes/rocket.tscn"),    cooldown = 6.0, group = "rocket_group" },
	{ scene = preload("res://scenes/upgrade.tscn"),   cooldown = 8.0, group = "upgrade_group" },
]

var score = 0
var is_paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() # seed random nubmer generator

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and $Player.visible == true: # PAUSED
		toggle_pause()
	check_score()
	
func toggle_pause():
	is_paused = !is_paused
	Globals.is_global_paused = is_paused
	$HUD.show_paused_label(is_paused)
	toggle_timers(is_paused)
	toggle_object_speeds(is_paused)
	
	# If you want the player to be hidden/disabled when paused, you can add this:
	if is_paused:
		$Player.speed = 0
	else:
		$Player.speed = Globals.player_speed
	
func toggle_timers(is_paused: bool) -> void:
	$AsteroidTimer.set_paused(is_paused)
	$BombTimer.set_paused(is_paused)
	$RocketTimer.set_paused(is_paused)
	$ShootCooldownBar/ResetCooldownTimer.set_paused(is_paused)
	$ShootCooldownBar/DecreaseProgressBar.set_paused(is_paused)
	
func toggle_object_speeds(is_paused: bool) -> void:
	var method_name = "pause" if is_paused else "resume"
	
	get_tree().call_group("asteroid_group", method_name)
	get_tree().call_group("bomb_group", method_name)
	get_tree().call_group("rocket_group", method_name)
	get_tree().call_group("bullet_group", method_name)

func new_game():
	score = 0
	get_tree().call_group("asteroid_group", "queue_free")
	get_tree().call_group("bomb_group", "queue_free")
	get_tree().call_group("rocket_group", "queue_free")
	get_tree().call_group("explosion_group", "queue_free")
	$HUD.update_score(score)
	$Player.start($StartPosition.position)
	$Player.visible = true
	$AsteroidTimer.start()
	$BombTimer.start()
	$RocketTimer.start()
	
func main_screen_transition():
	$HUD.show_main()
	
func game_over():
	$HUD.show_game_over()
	main_screen_transition()
	
func update_score_from_asteroid() -> void:
	score+=1
	$HUD.update_score(score)
	
func _on_asteroid_timer_timeout() -> void:
	var asteroid = asteroid_scene.instantiate()
	var asteroid_spawn_location = $AsteroidPath/AsteroidSpawnLocation
	asteroid_spawn_location.progress_ratio = randf()
	asteroid.global_position = asteroid_spawn_location.position
	add_child(asteroid)
	
func _on_bomb_timer_timeout() -> void:
	var bomb = bomb_scene.instantiate()
	var bomb_spawn_location = $AsteroidPath/AsteroidSpawnLocation
	bomb_spawn_location.progress_ratio = randf()
	bomb.global_position = bomb_spawn_location.position
	add_child(bomb)

func _on_rocket_timer_timeout() -> void:
	#var rocket = preload("res://scenes/rocket.tscn").instantiate()
	var rocket = rocket_scene.instantiate()
	var rocket_spawn_location = $AsteroidPath/AsteroidSpawnLocation
	rocket_spawn_location.progress_ratio = randf()
	rocket.global_position = rocket_spawn_location.position
	add_child(rocket)

func check_score():
	if score % 2 != 0 and !Globals.repair_upgrade_up:
		var upgrade = upgrade_scene.instantiate()
		var upgrade_spawn_location = $StartPosition
		upgrade.global_position = upgrade_spawn_location.global_position
		add_child(upgrade)
