extends Node2D

export var item = ""
export var itemText = ""
export var looted = false

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		body.get_node("ExclamationMark").show()
		body.get_node("ExclamationMark").play("info")


func _on_Area2D_body_exited(body):
	if body.get_name() == "Player":
		body.get_node("ExclamationMark").hide()
