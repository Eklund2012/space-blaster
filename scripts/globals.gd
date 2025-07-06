extends Node
var screen_size: Vector2

var selected_skin_path = ""
var selected_skin_path_index = 0 # default skin as standard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
