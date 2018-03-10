extends Area2D

export(String, FILE, "*.tscn") var nextScene

func _on_Area2D_body_entered( body ):
	if body.get_name() == "Player":
		global.goto_scene(nextScene)
