extends Area2D

const PROJECTILE_SPEED = 250
export(Vector2) var motion

func _ready():
	set_process(true)

func _process(delta):
	if motion == Vector2(0,0):
		motion = Vector2(0,1)
	set_position(get_position() + motion * delta * PROJECTILE_SPEED)

func _on_VisibilityNotifier2D_screen_exited():
	print("Exited screen")
	queue_free()



func _on_Area2D_body_entered( body ):
	if (body.has_node("Enemy")):
		print("hit enemy")
		global.score += 1
		#body.queue_free()
		body.died()
		global.UI.updateScore(global.score)
		queue_free()
		
