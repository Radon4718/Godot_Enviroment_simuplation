extends Node2D

@export var maxFlies = 10

var children
var fly = preload("res://scenes/Fly.tscn")
var spawn = 60 * 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	children = get_children()
	
	if children.size() < maxFlies:
		var newFly = fly.instantiate()
		
		var size = DisplayServer.window_get_size_with_decorations()
		
		newFly.position = Vector2(randf_range(40, size.x - 40), randf_range(40, size.y - 40))
		add_child(newFly)
	
			
	pass
