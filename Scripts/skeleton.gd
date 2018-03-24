extends KinematicBody2D

signal gotHit

#Damage inflicted by enemy
const DAMAGE = 3
const SPEED = 20

var pursuing = false
var dead = false
var previousMotion = Vector2()

func _ready():
	self.add_to_group("enemy_group")

func _process(delta):
	if !dead:
		walk(delta)
	
func died():
	dead = true
	$AnimatedSprite.play("dead")
	#Wait for a second before removing node from scene
	#TODO: fade out animation instead of instantly deleting enemy
	$Fade_Timer.start()
	yield($Fade_Timer, "timeout")
	queue_free()


func _on_Area2D_body_entered( body ):
	if body.get_name() == "Player" && !dead:
		print("damage")
		global.Player.getDamage(DAMAGE)
		

func walk(delta):
	var playerPos = global.Player.position
	var enemyPos = self.position
	var pursuingSpeed = 1
	
	if pursuing:
		pursuingSpeed = 2.5
		
	if enemyPos.distance_to(playerPos) < 150:
		pursuing = true
	else:
		pursuing = false
	
	var motion = (playerPos - enemyPos).normalized()
	walk_animation(motion)
	previousMotion = motion
	enemyPos += motion * SPEED * delta * pursuingSpeed
	self.position = enemyPos
		

func walk_animation(motion):
	var angle = -rad2deg(global.Player.position.angle_to_point(position))
	
	if angle >= 0 and angle <= 180:
		if angle >= 0 and angle <= 55:
			$AnimatedSprite.play("walk_right")
		elif angle > 55 and angle <= 125:
			$AnimatedSprite.play("walk_up")
		elif angle > 125:
			$AnimatedSprite.play("walk_left")
	elif angle >= -180 and angle < 0:
		if angle >= -180 and angle <= -125:
			$AnimatedSprite.play("walk_left")
		elif angle > -125 and angle <= -90:
			$AnimatedSprite.play("walk_down")
		elif angle > -90 and angle <= -55:
			$AnimatedSprite.play("walk_right")