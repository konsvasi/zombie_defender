extends KinematicBody2D

const ACCELERATION = 60
const SPEED = 55



func _physics_process(delta):
	var motion = Vector2()
	if Input.is_action_pressed("ui_down"):
		motion.y += 1
		$Sprite.play("walk_down")
	if Input.is_action_pressed("ui_up"):
		motion.y -= 1
		$Sprite.play("walk_up")
	if Input.is_action_pressed("ui_left"):
		motion.x -= 1
		$Sprite.play("walk_left")
	if Input.is_action_pressed("ui_right"):
		motion.x += 1
		$Sprite.play("walk_right")
	if motion.length() > 0:
		motion = motion.normalized() * SPEED
	else:
		$Sprite.play("idle")
	
	move_and_slide(motion)



