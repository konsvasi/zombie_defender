extends Node2D

export (PackedScene) var enemies

func _ready():
	randomize()


func _on_enemyTimer_timeout():
	$EnemyPath/spawnLocation.set_offset(randi())
	var enemy = enemies.instance()
	add_child(enemy)
	enemy.get_node("AnimatedSprite").play("walk_down")
	
	var direction = $EnemyPath/spawnLocation.rotation + PI/2
	enemy.position = $EnemyPath/spawnLocation.position
	direction += rand_range(-PI/4, PI/4)
	#enemy.set_linear_velocity(Vector2(rand_range(20, 85), 0).rotated(direction))
	enemy.move_and_slide(Vector2())