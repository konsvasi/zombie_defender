extends KinematicBody2D

const ACCELERATION = 60
const SPEED = 55
var health = 50
var maxHealth = 50
var motion2 

onready var shootTimer = $ShootTimer
signal hitEnemy
signal gameOver
const PARTICLE_SCENE = preload("res://Scenes/Particle.tscn")


func _process(delta):
	if global.health <= 0:
		resetPlayerStats()
		emit_signal("gameOver")

func _ready():
	global.Player = self

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
	shootTimer.stop()
	
#Function that handles the damage that user takes from an enemy
func getDamage(damage):
	global.health -= damage
	global.UI.updateHealth(global.health)
	
#Resets the player stats after a game over
func resetPlayerStats():
	global.health = health

#Resets position of the player after a game over
func resetPosition(startPosition):
	set_global_position(startPosition)
