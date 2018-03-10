extends KinematicBody2D

signal gotHit

#Damage inflicted by enemy
const DAMAGE = 3

func _ready():
	self.add_to_group("enemy_group")

func _process(delta):
	pass
	
func died():
	$AnimatedSprite.play("dead")
	
	#Wait for a second before removing node from scene
	#TODO: fade out animation instead of instantly deleting enemy
	$Fade_Timer.start()
	yield($Fade_Timer, "timeout")
	queue_free()


func _on_Area2D_body_entered( body ):
	if body.get_name() == "Player":
		global.Player.getDamage(DAMAGE)
		
