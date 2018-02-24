extends CanvasLayer

signal start_game

func _ready():
	global.UI = self

func updateScore(score):
	$ScoreLabel/Score.text = str(score)

func updateHealth(health):
	$HealthLabel/Health.text = str(health)
	
func showGameOver():
	toggleScoreAndHealthLabels(false)
	$MessageLabel.text = "You Died"
	$StartButton.show()


func _on_StartButton_pressed():
	$StartButton.hide()
	toggleScoreAndHealthLabels(true)
	emit_signal("start_game")

func toggleScoreAndHealthLabels(show):
	if show:
		$ScoreLabel.show()
		$HealthLabel.show()
	else:
		$ScoreLabel.hide()
		$HealthLabel.hide()


func _on_Player_hitEnemy():
	print("UI UPDATE")
	updateScore(global.score)
