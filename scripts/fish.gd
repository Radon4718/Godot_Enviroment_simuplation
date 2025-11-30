extends CharacterBody2D

@onready var collision = $sight
@export var spawnAfter = 3

const speed = 80.0

var alive = true
var hasEaten = false
var hasTarget = false
var hasGoal = false
var acc = Vector2(0,0)

var target = Vector2(0,0)
var target_body 

var dir = 0
var eatingTime = 0 ;
var eaten = false
var numEaten  = 0;

#### Signals #####
signal direction_changed(direction)
signal lay_egg()

func _ready() -> void:
	velocity = Vector2(0,0)
	pass
func _physics_process(delta: float) -> void:
	update()


func update():
	if alive:
		
		if hasGoal:
			if(target - position).length() < 10:
				hasGoal = false
			
		if !hasTarget and !hasGoal:
			var rand1 = randf_range(-300 + position.x, 300 + position.x)				
			var rand2 = randf_range(-300 + position.y, 300 + position.y)
			target = Vector2(rand1,rand2)
			target = validateGoal(target)
			hasGoal = true
		elif hasTarget:
			target = target_body.position
		
		
		
		var desired_velocity = (target - position).normalized() * speed
		applyForce(velocity.lerp(desired_velocity, 0.05))
		velocity = acc
		move_and_slide()
		
		acc *= 0
	
		
		var prevDir = dir
		if velocity.x > 3:
			dir = 1
			#if(hasTarget): hasTarget = false
		if velocity.x < -3:
			dir = 0
			#if(hasTarget): hasTarget = false
		if(prevDir != dir):
			emit_signal("direction_changed",dir)
		
		checkEdges()
		calculateEatingTime()
	pass
	
func applyForce(force: Vector2):
	acc += force
	pass
	
func validateGoal(goal: Vector2) -> Vector2:
	var sizex = DisplayServer.window_get_size().x
	var sizey = DisplayServer.window_get_size().y
	var margin = 40

	var goalx = clamp(goal.x, margin, sizex - margin)
	var goaly = clamp(goal.y, margin, sizey - margin)

	if goalx != goal.x:
		goalx = randf_range(margin, sizex - margin)
	if goaly != goal.y:
		goaly = randf_range(margin, sizey - margin)

	return Vector2(goalx, goaly)

func _process_goal():
	if (not hasTarget) and (not hasGoal):
		var random_goal = get_random_goal(300)
		target = validateGoal(random_goal)
		hasGoal = true

func get_random_goal(radius: float = 300.0) -> Vector2:
	var rand_offset = Vector2(
		randf_range(-radius, radius),
		randf_range(-radius, radius)
	)
	return position + rand_offset

func calculateEatingTime():
	if eaten:
		eatingTime = 60 * 6
		eaten = false
	else: eatingTime -= 1
	if numEaten == spawnAfter: 
		numEaten = 0
		emit_signal("lay_egg")
	pass

func checkEdges() -> void:
	var display_size = DisplayServer.window_get_size_with_decorations()
	var margin = 30

	if position.x > display_size.x - margin:
		position.x = display_size.x - margin

	if position.x < margin:
		position.x = margin

	if position.y > display_size.y - margin:
		position.y = display_size.y - margin

	if position.y < margin:
		position.y = margin



func _on_sight_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Bug") and !eaten and !hasTarget and !target_body):
		hasTarget = true
		target_body = body
	pass 


func _on_sight_body_exited(body: Node2D) -> void:
	if body.is_in_group("Bug"):
		hasTarget = false
		target_body = null
	pass 


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bug"):
		body.alive = false
		numEaten += 1
		eaten = true
	pass
