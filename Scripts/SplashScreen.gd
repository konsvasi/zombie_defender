extends Node2D

export(String, FILE, "*.tscn") var nextScene

func _ready():
	$Label/AnimationPlayer.play("fade_in")
	yield($Label/AnimationPlayer, "animation_finished")
	global.goto_scene(nextScene)
