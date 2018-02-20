extends Area2D

export var nextScene = ""

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_Area2D_body_entered( body ):
	global.goto_scene(nextScene)
