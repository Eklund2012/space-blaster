extends Area2D

@export var min_move_speed := 250.0
@export var max_move_speed := 300.0

var move_speed := 0.0

var velocity := Vector2.ZERO
var saved_velocity = Vector2.ZERO
var saved_rotation = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_speed = randf_range(min_move_speed, max_move_speed)
	# Move toward center of screen
	var screen_center = get_viewport_rect().size / 2
	velocity = (screen_center - global_position ).normalized() * move_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position  += velocity * delta
	if velocity == Vector2.ZERO:
		rotation = saved_velocity.angle()
	else:
		rotation = velocity.angle()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Player":
		if area.state == "alive":
			#area.take_damage()
			spawn_explosion()
			queue_free()
		else:
			return
	spawn_explosion()
	queue_free()

func spawn_explosion():
	var explosion_scene = preload("res://scenes/Explosion.tscn")  # Adjust path
	var explosion = explosion_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position

func pause():
	saved_velocity = velocity
	saved_rotation = rotation
	velocity = Vector2.ZERO

func resume():
	velocity = saved_velocity
