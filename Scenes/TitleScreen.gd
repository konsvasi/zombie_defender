extends Node2D

export(String, FILE, "*.tscn") var nextScene

func _on_NewGameBtn_pressed():
	print("button pressed")
	global.goto_scene(nextScene)