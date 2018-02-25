extends CanvasLayer

signal start_game

func _ready():
	global.UI = self

func updateScore(score):
	$ScoreLabel/Score.text = str(score)

func updateHealth(health):
	$HealthLabel/Healthbar.value = global.health
	
func showGameOver():
	toggleScoreAndHealthLabels(false)
	$MessageLabel.text = "You Died"
	$MessageLabel.show()
	$StartButton.show()


func _on_StartButton_pressed():
	print("starting a new game")
	print($StartButton.get_instance_id())
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

func setupHealthbar():
	$Healthbar.max_value = global.Player.maxHealth
	$Healthbar.min_value = 0
	$Healthbar.value = global.Player.health
