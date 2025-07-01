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
	
func update_health(health: int) -> void:
	$HealthLabel.text = "Health: " + str(health)
	
func show_game_over():
	toggle_visible_components(true)
	
func toggle_visible_components(state: bool):
	$GameOverLabel.visible = state
	$PlayButton.visible = state
	$MenuButton.visible = state

func _on_play_button_button_down() -> void:
	toggle_visible_components(false)
	start_game.emit()

func _on_menu_button_button_down() -> void:
	print("Menu button down")
