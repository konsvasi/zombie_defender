extends KinematicBody2D

const SPEED = 80
const DOWN = Vector2(0, 1)
const UP = Vector2(0, -1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)
const PARTICLE_SCENE = preload("res://Scenes/Particle.tscn")

onready var world = get_world_2d().get_direct_space_state()
var health = 50
var maxHealth = 50
var currentScene
var faceDirection = "down"
var dashSpeed = 1
var dashTimer = Timer.new()
onready var shootTimer = $ShootTimer
onready var state = global.state
signal hitEnemy
signal gameOver
var equipment = {
	"weapon": "",
	"boots": ""
}

#var inventory = ["Potion", "Painkiller", "Potion"]
# Inventory is an array that contains item objects
var inventory = [{"name": "Potion", "count": 2}, {"name": "Hi-potion", "count": 1}]

func _process(delta):
	if global.health <= 0:
		resetPlayerStats()
		emit_signal("gameOver")

func _ready():
	global.Player = self

func _physics_process(delta):
	var motion = Vector2()
	
	if global.state == "walking":
		if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down"):
			motion += LEFT
			$Sprite.play("walk_left")
			faceDirection = "left"
		elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_up"):
			motion += LEFT
			$Sprite.play("walk_left")
			faceDirection = "left"
		elif Input.is_action_pressed("ui_left"):
			motion += LEFT
			$Sprite.play("walk_left")
			faceDirection = "left"
		
		if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_down"):
			motion += RIGHT
			$Sprite.play("walk_right")
			faceDirection = "right"
		elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_up"):
			motion += RIGHT
			$Sprite.play("walk_right")
			faceDirection = "right"
		elif Input.is_action_pressed("ui_right"):
			motion += RIGHT
			$Sprite.play("walk_right")
			faceDirection = "right"
		
		var animation = $Sprite.get_animation()
		if Input.is_action_pressed("ui_up"):
			motion += UP
			if motion.x == 0:
				$Sprite.play("walk_up")
				faceDirection = "up"
			else:
				$Sprite.play(animation)
	
		if Input.is_action_pressed("ui_down"):
			motion += DOWN
			if motion.x == 0:
				$Sprite.play("walk_down")
				faceDirection = "down"
			else:
				$Sprite.play(animation)
				
		if Input.is_action_pressed("dash"):
			#check if player has equipment that enables dash
			if typeof(equipment.boots) == TYPE_ARRAY and equipment.boots[1] == "DASH_EQUIPMENT":
				if dashTimer.is_stopped():
					dashSpeed = equipment.boots[2]
					createDashTimer(dashSpeed)
				else:
					dashSpeed = 1
		
		if Input.is_action_pressed("interact"):
			getIntersection(faceDirection)
		
		if Input.is_action_just_pressed("ui_accept"):
			global.UI.toggleMenu()
	
	
		if Input.is_action_pressed("shoot"):
			shoot(motion)
		
		if motion.length() > 0:
			motion = motion.normalized() * SPEED * dashSpeed
		else:
			$Sprite.stop()
			$Sprite.set_frame(2)
	
		move_and_slide(motion)

func shoot(motion):
	var position = $Gun/Position2D.get_position()
	createParticle(motion)
	
func createParticle(motion):
	if shootTimer.is_stopped():
		var particle = PARTICLE_SCENE.instance()
		particle.motion = motion
		get_parent().add_child(particle)
		particle.set_position($Gun/Position2D.get_global_position())
		
		restartTimer(shootTimer, 0.5)

func _on_ShootTimer_timeout():
	shootTimer.stop()
	
# Handles the damage that user takes from an enemy
func getDamage(damage):
	global.health -= damage
	global.UI.updateHealth(global.health)
	
# Resets the player stats after a game over
func resetPlayerStats():
	global.health = health

# Resets position of the player after a game over
func resetPosition(startPosition):
	set_global_position(startPosition)

# Gets intersection point by using the players direction
# Result is given to interact function to check
# if there is anything in the result that player can interact with	
func getIntersection(faceDirection):
	var result
	if faceDirection == "left":
		result = world.intersect_point(position + Vector2(-16, 0))
	elif faceDirection == "right":
		result = world.intersect_point(position + Vector2(16, 0))
	elif faceDirection == "down":
		result = world.intersect_point(position + Vector2(0, 16))
	elif faceDirection == "up":
		result = world.intersect_point(position + Vector2(0, -16))
	
	interact(result)

# Checks if player faces an object that can be interacted with
func interact(interSectionPoint):
	for dict in interSectionPoint:
		if typeof(dict.collider) == TYPE_OBJECT and dict.collider.has_node("Interact"):
			#get parent of collider
			var box = dict.collider.get_parent()
			
			$ExclamationMark.hide()
			if !box.looted:
				box.get_node("AnimatedSprite").play("open")
				#Show dialog
				var dialogBox = global.UI.get_node("DialogBox")
				global.state = "dialog"
				dialogBox.get_node("RichTextLabel").set_bbcode(box.itemText)
				dialogBox.show()
				equipment.boots = box.itemArray
				print("Got: ", box.item, " equipment: ", equipment)
				box.looted = true

func createDashTimer(dashSpeed):
	dashTimer.connect("timeout", self, "_on_dashTimer_timeout")
	dashTimer.wait_time = 3
	add_child(dashTimer)
	dashTimer.start()
	restartTimer(dashTimer, 2)

# Sets the dashSpeed back to normal	
func _on_dashTimer_timeout():
	dashTimer.stop()
	dashTimer.disconnect("timeout", self, "_on_dashTimer_timeout")
	remove_child(dashTimer)
	
func restartTimer(timer, waitTime):
	timer.set_wait_time(waitTime)
	timer.start()