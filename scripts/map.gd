extends Node3D

@onready var light = $SpotLights
var turn_night_lights = false
func _ready() -> void: pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.turn_night_lights and not turn_night_lights:
		# Loop Through All Lights and Turn Them On
		for i in range(light.get_child_count()):
			var child = light.get_child(i)
			if child is SpotLight3D:
				print("Spotlight Turned On")
				var spotlight : SpotLight3D = child
				spotlight.show()
		turn_night_lights = true
		print("Turn Night Lights On")
	elif not Globals.turn_night_lights and turn_night_lights:
		# Loop Through All Lights and Turn Them Off
		for i in range(light.get_child_count()):
			var child = light.get_child(i)
			if child is SpotLight3D:
				print("Spotlight Turned Off")
				var spotlight : SpotLight3D = child
				spotlight.hide()
		turn_night_lights = false
		print("Turn Night Lights Off")
