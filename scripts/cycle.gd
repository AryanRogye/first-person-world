extends Node3D

@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animation.is_playing():
		var current_time = animation.current_animation_position
		var max_time = animation.current_animation_length
		var quarter_length = max_time / 4
		if (current_time < quarter_length) or (current_time >= (max_time - quarter_length)):
			Globals.turn_night_lights = true
		else:
			Globals.turn_night_lights = false
