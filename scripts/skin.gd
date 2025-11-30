extends AnimatedSprite2D
@onready var _animated_sprite = get("res://scenes/Fish.tscn::SpriteFrames_0l7gy")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var fish = get_parent()
	fish.connect("direction_changed",change_direction)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_direction(direction):
	if(direction == 1):
		animation = "swimming_right"
		sprite_frames.set_animation_loop("swimming_right",true)
	if(direction == 0):
		animation = "swimming_left"
		sprite_frames.set_animation_loop("swimming_left",true)
	pass
