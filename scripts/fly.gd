extends CharacterBody2D

const speed = 40.0
var acc = Vector2.ZERO
var run_from = Vector2.ZERO
var run_body: Node2D = null

var alive = true
var isTarget = false
var target: Vector2
var hasGoal = false

var stamina = 100.0

func _physics_process(delta: float) -> void:
	
	if not alive:
		queue_free()
		return
	
	if hasGoal and position.distance_to(target) < 10:
		hasGoal = false
		velocity = Vector2.ZERO

	
	if (not isTarget) and (not hasGoal) :
		var rand1 = randf_range(-300 + position.x, 300 + position.x)				
		var rand2 = randf_range(-300 + position.y, 300 + position.y)
		target = Vector2(rand1,rand2)
		target = validateGoal(target)
		hasGoal = true
	elif isTarget:
		target = run_body.position
	
	
	
	var desired_velocity = (target - position).normalized() * speed
	
	if isTarget:
		desired_velocity *= -1
	
	if(isTarget) and stamina > 0 and stamina <= 100:
		desired_velocity *= 3
		stamina -= 5
	else:
		stamina += 1
	
	applyForce(desired_velocity)
		
	velocity = acc
	
	move_and_slide()
	
	acc *= 0
	

	if velocity.length() > speed:
		velocity = velocity.normalized() * speed
	
	if(stamina > 100.0) : stamina = 100.0
	if(stamina <= 0.0): stamina = 0.0
	
	checkEdges()

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
	if (not isTarget) and (not hasGoal):
		var random_goal = get_random_goal(300)
		target = validateGoal(random_goal)
		hasGoal = true

func get_random_goal(radius: float = 300.0) -> Vector2:
	var rand_offset = Vector2(
		randf_range(-radius, radius),
		randf_range(-radius, radius)
	)
	return position + rand_offset


func checkEdges() -> void:
	var display_size = DisplayServer.window_get_size()
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
	if body.is_in_group("Fish"):
		isTarget = true
		run_body = body
	pass

func _on_sight_body_exited(body: Node2D) -> void:
	if body.is_in_group("Fish"):
		isTarget = false
		hasGoal = false
		run_body = null
	pass 
