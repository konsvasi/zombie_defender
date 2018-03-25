extends Node

const titleScene = "res://Scenes/TitleScreen.tscn"

var current_scene = null
var previous_scene = null
var health = 10
var score = 0
var UI
var Player
var isNewGame = true
var state

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	print(current_scene)
	state = "walking"
	
func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	current_scene.free()
	
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	
# Updates the UI after entering a new scene
func updateUI():
	UI.updateScore(global.score)
	UI.updateHealth(global.health)