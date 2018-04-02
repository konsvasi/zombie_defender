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
	
func showMenu():
	global.World.get_tree().paused = true
	$Menu.show()

func toggleMenu():
	var worldTree = global.World.get_tree()
	print("Visible: ", $Menu.visible)
	if $Menu.visible:
		$Menu.hide()
		worldTree.paused = false
	elif !$Menu.visible:
		$Menu.show()
		worldTree.paused = true
		

func setupHealthbar():
	$Healthbar.max_value = global.Player.maxHealth
	$Healthbar.min_value = 0
	$Healthbar.value = global.Player.health
