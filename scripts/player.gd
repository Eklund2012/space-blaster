extends Area2D

@export var speed := 0
@export var rotation_speed := 180 # Degrees per second
@export var bullet_scene: PackedScene
@export var max_health := 3
var health := max_health
var start_pos = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var texture: Texture2D
	if Globals.selected_skin_path != "":
		texture = load(Globals.selected_skin_path) as Texture2D
	else:
		texture = preload("res://assets/art/player1.png")
	$Sprite2D.texture = texture
	
func start(pos):
	position = pos
	start_pos = pos
	rotation = 0
	show()
	$CollisionShape2D.disabled = false
	health = max_health
	speed = 200

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
	if position.x <= 0 or position.x >= Globals.screen_size.x or position.y <= 0 or position.y >= Globals.screen_size.y:
		take_damage(1)
		self.position = start_pos

		
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
	$Sprite2D.material.set_shader_parameter("opacity", 0.7);
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
	speed = 0
	$CollisionShape2D.disabled = true
	get_tree().get_current_scene().game_over()


func _on_take_damage_shader_timer_timeout() -> void:
	$Sprite2D.material.set_shader_parameter("opacity", 1.0);
	$Sprite2D.material.set_shader_parameter("r", 0.0);
	$Sprite2D.material.set_shader_parameter("g", 0.0);
	$Sprite2D.material.set_shader_parameter("b", 0.0);
	$Sprite2D.material.set_shader_parameter("mix_color", 0.0);


func _on_area_entered(area: Area2D) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	pass
