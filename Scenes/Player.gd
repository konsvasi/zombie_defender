extends KinematicBody2D

const ACCELERATION = 20
const MAX_SPEED = 85
var motion = Vector2()


func _physics_process(delta):
	if Input.is_action_pressed("ui_down"):
		motion.y = min(motion.y + ACCELERATION, MAX_SPEED)
		$Sprite.play("walk_down")
	elif Input.is_action_pressed("ui_up"):
		motion.y = max(motion.y - ACCELERATION, -MAX_SPEED)
		$Sprite.play("walk_up")
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		$Sprite.play("walk_left")
	elif Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		$Sprite.play("walk_right")
	else:
		motion = Vector2(0, 0)
		$Sprite.play("idle")
	
	move_and_slide(motion)
