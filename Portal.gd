extends Area2D

export(String, FILE, "*.tscn") var nextScene

func _on_Area2D_body_entered( body ):
	global.goto_scene(nextScene)
