extends Node2D

var fish = preload("res://scenes/Fish.tscn")
@export var maxFish = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
			
	pass


func _on_fish_body_lay_egg() -> void:
	var children = get_children()
	if children.size() < maxFish:
		var newFish = fish.instantiate()
		add_child(newFish)
		
	pass # Replace with function body.
