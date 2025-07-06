extends CanvasLayer

var skin_paths = [
	"res://assets/art/player_skins/player1.png",
	"res://assets/art/player_skins/player2.png",
	"res://assets/art/player_skins/player3.png",
]
var current_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_index = Globals.selected_skin_path_index
	update_preview()
	
func update_preview():
	var texture = load(skin_paths[current_index]) as Texture2D
	$Control/PreviewNode.texture = texture
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	# Save selected skin path to a global singleton or pass it to the next scene
	Globals.selected_skin_path = skin_paths[current_index]
	Globals.selected_skin_path_index = current_index
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_previous_pressed() -> void:
	current_index = (current_index - 1 + skin_paths.size()) % skin_paths.size()
	update_preview()

func _on_next_pressed() -> void:
	current_index = (current_index + 1) % skin_paths.size()
	update_preview()
