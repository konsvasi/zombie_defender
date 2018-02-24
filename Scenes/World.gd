extends Node2D

export (PackedScene) var enemies
var score
var enemyCount = 0
onready var health = $Player.health

func _ready():
	randomize()

func _process(delta):
	if health <= 0:
		gameOver()

func _on_enemyTimer_timeout():
	$EnemyPath/spawnLocation.set_offset(randi())
	var enemy = enemies.instance()
	
	add_child(enemy)
	enemy.get_node("AnimatedSprite").play("walk_down")
	
	enemyCount += 1
	if enemyCount >= 10:
		$enemyTimer.stop()
		
	
	var direction = $EnemyPath/spawnLocation.rotation + PI/2
	enemy.position = $EnemyPath/spawnLocation.position
	direction += rand_range(-PI/4, PI/4)
	enemy.move_and_slide(Vector2())
	
func newGame():
	health = $Player.health
	$enemyTimer.start()
	$UI.updateScore(global.score)
	$UI.updateHealth(health)

func gameOver():
	$UI.showGameOver()


func _on_UI_start_game():
	newGame()
