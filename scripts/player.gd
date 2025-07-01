extends Area2D

@export var speed := 200
@export var rotation_speed := 180 # Degrees per second
@export var bullet_scene: PackedScene
@export var max_health := 3
var health := max_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func start(pos):
	position = pos
	rotation = 0
	show()
	$CollisionShape2D.disabled = false
	health = max_health

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

	position = position.clamp(Vector2.ZERO, Globals.screen_size)

	# Animate movement
	#if velocity.length() > 0:
		#$AnimatedSprite2D.play()
	#else:
		#$AnimatedSprite2D.stop()

	# Shoot
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	bullet.rotation = rotation
	get_parent().add_child(bullet)
	bullet.add_to_group("bullets")
	
func take_damage(amount: int = 1) -> void:
	$Sprite2D.material.set_shader_parameter("opacity", 1.0);
	$Sprite2D.material.set_shader_parameter("r", 1.0);
	$Sprite2D.material.set_shader_parameter("g", 0.0);
	$Sprite2D.material.set_shader_parameter("b", 0.0);
	$Sprite2D.material.set_shader_parameter("mix_color", 0.95);
	$TakeDamageShaderTimer.start()
	
	health -= amount
	get_tree().get_current_scene().get_node("HUD").update_health(health)
	if health <= 0:
		die()

func die() -> void:
	hide()
	$CollisionShape2D.disabled = true
	get_tree().get_current_scene().game_over()


func _on_take_damage_shader_timer_timeout() -> void:
	$Sprite2D.material.set_shader_parameter("opacity", 1.0);
	$Sprite2D.material.set_shader_parameter("r", 0.0);
	$Sprite2D.material.set_shader_parameter("g", 0.0);
	$Sprite2D.material.set_shader_parameter("b", 0.0);
	$Sprite2D.material.set_shader_parameter("mix_color", 0.0);
