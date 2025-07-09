extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ExplosionAudioStreamPlayer2D.play()
	var random_index = randi_range(1, 3)
	var animation_name = "explosion_%d" % random_index
	$AnimatedSprite2D.play(animation_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Player":
		area.take_damage()
