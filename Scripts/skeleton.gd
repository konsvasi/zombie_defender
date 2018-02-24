extends KinematicBody2D

signal gotHit

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	pass
	
func died():
	$AnimatedSprite.play("dead")
