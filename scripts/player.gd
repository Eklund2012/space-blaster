extends Area2D

@export var speed := 0
@export var rotation_speed := 280 # Degrees per second
@export var bullet_scene: PackedScene
@export var max_health := 1

var health := max_health
var start_pos = 0
var state = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var texture: Texture2D
	if Globals.selected_skin_path != "":
		texture = load(Globals.selected_skin_path) as Texture2D
	else:
		texture = preload("res://assets/art/player_skins/player1.png")
	$Sprite2D.texture = texture
	
func start(pos):
	state = "alive"
	position = pos
	start_pos = pos
	rotation = 0
	show()
	$CollisionShape2D.disabled = false
	health = max_health
	speed = 250

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Rotate with left/right
	if Input.is_action_pressed("move_right"):
		rotation_degrees += rotation_speed * delta
	if Input.is_action_pressed("move_left"):
		rotation_degrees -= rotation_speed * delta

	# Always move forward
	var velocity = Vector2.UP.rotated(rotation) * speed
	position += velocity * delta
		
	# Shoot
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	if get_tree().get_current_scene().has_node("ShootCooldownBar"):
		var cooldown_bar = get_tree().get_current_scene().get_node("ShootCooldownBar")
		cooldown_bar.add_to_cooldownbar(5)
	else:
		return
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	bullet.rotation = rotation
	get_parent().add_child(bullet)
	bullet.add_to_group("bullets")

func take_damage(amount: int = 1) -> void:
	$Sprite2D.material.set_shader_parameter("opacity", 0.7);
	$Sprite2D.material.set_shader_parameter("r", 1.0);
	$Sprite2D.material.set_shader_parameter("g", 0.0);
	$Sprite2D.material.set_shader_parameter("b", 0.0);
	$Sprite2D.material.set_shader_parameter("mix_color", 0.95);
	$TakeDamageShaderTimer.start()
	
	health -= amount
	get_tree().get_current_scene().get_node("HUD").update_health(health)
	if health == 0 and state == "alive":
		die()
		spawn_explosion()

func spawn_explosion():
	var explosion_scene = preload("res://scenes/Explosion.tscn")  # Adjust path
	var explosion = explosion_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position

func die() -> void:
	hide()
	state = "dead"
	speed = 0
	$CollisionShape2D.disabled = true
	get_tree().get_current_scene().game_over()

func _on_take_damage_shader_timer_timeout() -> void:
	$Sprite2D.material.set_shader_parameter("opacity", 1.0);
	$Sprite2D.material.set_shader_parameter("r", 0.0);
	$Sprite2D.material.set_shader_parameter("g", 0.0);
	$Sprite2D.material.set_shader_parameter("b", 0.0);
	$Sprite2D.material.set_shader_parameter("mix_color", 0.0);


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	take_damage(1)
	self.position = start_pos
