extends Area2D

export(String, FILE, "*.tscn") var nextScene

func _on_Area2D_body_entered( body ):
	global.previous_scene = global.current_scene.get_name()
	if body.get_name() == "Player":
		global.goto_scene(nextScene)
