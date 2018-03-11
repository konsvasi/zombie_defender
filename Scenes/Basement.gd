extends Node2D

func _ready():
	global.updateUI()
	global.Player.set_position($Position2D.get_position())
	global.Player.show()

## Updates the UI after entering a new scene
#func updateUI():
#	$UI.updateScore(global.score)
#	$UI.updateHealth(global.health)

