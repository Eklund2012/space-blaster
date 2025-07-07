extends CanvasLayer
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_score(score):
	$ScoreLabel.text = "Score: " + str(score)
	
func show_game_over():
	toggle_visible_components(true)

func show_main():
	$SpaceBlaster.visible = true
	$PlayButton.visible = true
	$MenuButton.visible = true
	
func toggle_visible_components(state: bool):
	$SpaceBlaster.visible = state
	$GameOverLabel.visible = state
	$PlayButton.visible = state
	$MenuButton.visible = state

func _on_play_button_button_down() -> void:
	$PlayButton/AudioPlay.play()
	toggle_visible_components(false)
	start_game.emit()

func _on_menu_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func show_paused_label(state: bool):
	$PausedLabel.visible = state
