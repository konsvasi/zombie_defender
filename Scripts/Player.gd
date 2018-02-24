extends KinematicBody2D

const ACCELERATION = 60
const SPEED = 55
var health = 50
var motion2 

onready var shootTimer = $ShootTimer

const PARTICLE_SCENE = preload("res://Scenes/Particle.tscn")

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
	if Input.is_action_pressed("shoot"):
		shoot(motion)
	if motion.length() > 0:
		motion = motion.normalized() * SPEED
	else:
		$Sprite.play("idle")
	motion2 = motion
	move_and_slide(motion)

func shoot(motion):
	var position = $Gun/Position2D.get_position()
	createParticle(motion)
	
func createParticle(motion):
	if shootTimer.is_stopped():
		var particle = PARTICLE_SCENE.instance()
		particle.motion = motion
		get_parent().add_child(particle)
		particle.set_position($Gun/Position2D.get_global_position())
		restartTimer()

func restartTimer():
	$ShootTimer.set_wait_time(0.5)
	$ShootTimer.start()


func _on_ShootTimer_timeout():
	print("timer")
	shootTimer.stop()
