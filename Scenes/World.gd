extends Node2D

export (PackedScene) var enemies
var score
var enemyCount = 0
onready var health = $Player.health

func _ready():
	randomize()

func _process(delta):
	if global.health <= 0:
		gameOver()

func _on_enemyTimer_timeout():
	$EnemyPath/spawnLocation.set_offset(randi())
	var enemy = enemies.instance()
	
	add_child(enemy)
	enemy.get_node("AnimatedSprite").play("walk_down")
	
	enemyCount += 1
	#if enemyCount >= 10:
	#	$enemyTimer.stop()
		
	
	enemy.position = $EnemyPath/spawnLocation.position
	enemy.move_and_slide(Vector2(2,1))
	
func newGame():
	health = $Player.health
	$enemyTimer.start()
	$UI.updateScore(global.score)
	$UI.updateHealth(health)

func gameOver():
	$UI.showGameOver()


func _on_UI_start_game():
	print("received signal")
	newGame()
