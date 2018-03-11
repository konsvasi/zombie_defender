extends Node2D

export (PackedScene) var enemies
var score
var enemyCount = 0
onready var health = $Player.health
onready var tree = get_tree()

func _ready():
	randomize()
	tree.paused = false
	newGame()

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
	tree.paused = true
	#reset score
	global.score = 0
	
	#move Player to start position
	#$Player.resetPosition($StartPosition.get_position())
	
	#Stop creation of new enemies
	$enemyTimer.stop()
	
	var enemies = tree.get_nodes_in_group("enemy_group")
	remove_enemies(enemies)
	$UI.showGameOver()

func remove_enemies(enemies):
	for enemy in enemies:
		enemy.queue_free()

func _on_Player_gameOver():
	gameOver()
