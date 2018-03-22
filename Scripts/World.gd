extends Node2D

export (PackedScene) var enemies
onready var health = $Player.health
onready var tree = get_tree()

var score
var enemyCount = 0
var isNewGame = true


func _ready():
	randomize()
	tree.paused = false
	
	if global.isNewGame:
		newGame()
	else:
		global.updateUI()
		$enemyTimer.start()
	
	# Positioning of player after switching scenes
	if global.previous_scene:
		if global.previous_scene == "Basement":
			global.Player.set_position($StartPosition.get_position())

func _on_enemyTimer_timeout():
	$EnemyPath/spawnLocation.set_offset(randi())
	var enemy = enemies.instance()
	
	add_child(enemy)
	enemy.get_node("AnimatedSprite").play("walk_down")
	
	enemyCount += 1
	if enemyCount == 1:
		$enemyTimer.stop()
		
	
	enemy.position = $EnemyPath/spawnLocation.position
	enemy.move_and_slide(Vector2(2,1))
	
func newGame():
	health = $Player.health
	$enemyTimer.start()
	$UI.updateScore(global.score)
	$UI.updateHealth(health)
	global.isNewGame = false

func gameOver():
	tree.paused = true
	#reset score
	global.score = 0
	global.isNewGame = true
		
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
