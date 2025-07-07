extends Node2D

var max_health = Globals.max_health
var current_health = Globals.current_health

var full_heart = preload("res://assets/art/full_heart.png")
#var empty_heart = preload("res://empty_heart.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_hearts(health):
	for i in range(max_health):
		var heart = $HeartsContainer.get_child(i)
		if i < health:
			heart.texture = full_heart
		else:
			heart.texture = null
