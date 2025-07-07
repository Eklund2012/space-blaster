extends Area2D

@export var speed := 600.0
var saved_position
var saved_speed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2.UP.rotated(rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func pause():
	saved_speed = speed
	speed = 0

func resume():
	speed = saved_speed
