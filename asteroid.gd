extends Area2D
@export var rotation_speed := 90.0 # degrees per second
@export var move_speed := 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees += rotation_speed * randf() * delta
	position.x += move_speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		queue_free()      # Remove asteroid
		area.queue_free() # Remove bullet
