extends Node2D

var shake_magnitude := 5
var shake_duration := 0.3
var shake_time := 0.0
var original_position := Vector2()

func _ready():
	original_position = $ProgressBarContainer.position

func _process(delta):
	if shake_time > 0:
		shake_time -= delta
		$ProgressBarContainer.position = original_position + Vector2(
			randf_range(-shake_magnitude, shake_magnitude),
			randf_range(-shake_magnitude, shake_magnitude)
		)
	else:
		$ProgressBarContainer.position = original_position

func add_to_cooldownbar(amount):
	$ProgressBarContainer/ProgressBar.value += amount
	if $ProgressBarContainer/ProgressBar.value >= $ProgressBarContainer/ProgressBar.max_value:
		start_shake()
	if $ResetCooldownTimer.is_stopped():
		$ResetCooldownTimer.start()
	$DecreaseProgressBar.stop()
	
func get_value():
	return $ProgressBarContainer/ProgressBar.value

func _on_reset_cooldown_timer_timeout() -> void:
	$DecreaseProgressBar.start()

func _on_decrease_progress_bar_timeout() -> void:
	$ProgressBarContainer/ProgressBar.value -= 10

func start_shake():
	shake_time = shake_duration
