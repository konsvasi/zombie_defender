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
	$GameOverMessage.text = "You Died"
	$GameOverMessage.show()
	# Wait 5 seconds, then resume execution
	yield(get_tree().create_timer(3.0), "timeout")
	global.goto_scene(global.titleScene)

func toggleScoreAndHealthLabels(show):
	if show:
		$ScoreLabel.show()
		$HealthLabel.show()
	else:
		$ScoreLabel.hide()
		$HealthLabel.hide()

func _on_Player_hitEnemy():
	updateScore(global.score)

func setupHealthbar():
	$Healthbar.max_value = global.Player.maxHealth
	$Healthbar.min_value = 0
	$Healthbar.value = global.Player.health
