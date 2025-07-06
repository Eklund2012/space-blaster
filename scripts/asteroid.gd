extends RigidBody2D

@export var min_rotation_speed := 180.0
@export var max_rotation_speed := 180.0

@export var min_move_speed := 80.0
@export var max_move_speed := 200.0

var move_speed := 100.0
var rotation_speed := 90.0
var velocity := Vector2.ZERO

func _ready() -> void:
	move_speed = randf_range(min_move_speed, max_move_speed)
	rotation_speed = randf_range(min_rotation_speed, max_rotation_speed)

	# Move toward center of screen
	var screen_center = get_viewport_rect().size / 2
	var direction = (screen_center - global_position).normalized()
	linear_velocity = direction * move_speed

	# Optional: spin while moving
	angular_velocity = deg_to_rad(rotation_speed)

func _process(delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		queue_free()
		area.queue_free()
		get_tree().get_current_scene().update_score_from_asteroid()
	elif area.name == "Player":
		area.take_damage()
		queue_free()
	elif area.is_in_group("explosions"):
		spawn_explosion()
		queue_free()

func spawn_explosion():
	var explosion_scene = preload("res://scenes/Explosion.tscn")  # Adjust path
	var explosion = explosion_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		queue_free()
		area.queue_free()
		get_tree().get_current_scene().update_score_from_asteroid()
	elif area.name == "Player":
		area.take_damage()
		queue_free()
	elif area.is_in_group("explosions"):
		spawn_explosion()
		queue_free()
