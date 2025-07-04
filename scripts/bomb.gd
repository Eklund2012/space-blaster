extends Area2D

@export var min_rotation_speed := 30.0
@export var max_rotation_speed := 180.0

@export var min_move_speed := 80.0
@export var max_move_speed := 200.0

var rotation_speed := 0.0
var move_speed := 0.0
var velocity := Vector2.ZERO

func _ready() -> void:
	rotation_speed = randf_range(min_rotation_speed, max_rotation_speed)
	move_speed = randf_range(min_move_speed, max_move_speed)

	# Move toward center of screen
	var screen_center = get_viewport_rect().size / 2
	velocity = (screen_center - position).normalized() * move_speed

func _process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		queue_free()      # Remove bomb
		area.queue_free() # Remove bullet
	elif area.name == "Player":
		#area.take_damage() not needed cuz player takes dmg from explosion instant
		queue_free()
	spawn_explosion()

func spawn_explosion():
	var explosion_scene = preload("res://scenes/Explosion.tscn")  # Adjust path
	var explosion = explosion_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position
