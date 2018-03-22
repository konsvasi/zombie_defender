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
	#print(motion.x < previousMotion.x)
	var newMotion = (motion - previousMotion).normalized()
	var rateX = motion.x - previousMotion.x
	var rateY = motion.y - previousMotion.y
	
	print("rateX: ", rateX)
	print("rateY: ", rateY)
	
	if rateX < 0 and rateY > 0:
		if rateX < rateY:
			$AnimatedSprite.play("walk_left")
		else: 
			$AnimatedSprite.play("walk_up")
	elif rateX > 0 and rateY > 0:
		if rateX < rateY:
			$AnimatedSprite.play("walk_right")
		else: 
			$AnimatedSprite.play("walk_up")
	elif rateX < 0 and rateY < 0:
		if rateX < rateY:
			$AnimatedSprite.play("walk_left")
		else: 
			$AnimatedSprite.play("walk_down")
	else:
		if rateX < rateY:
			$AnimatedSprite.play("walk_left")
		else: 
			$AnimatedSprite.play("walk_up")