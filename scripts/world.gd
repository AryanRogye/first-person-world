extends Node3D

@onready var player = $Player

func _ready() -> void:
	$PauseMenu.visible = false

	get_node("PauseMenu/MarginContainer/HBoxContainer/VBoxContainer/resume").connect("pressed", Callable(self, "handleResume"))
	get_node("PauseMenu/MarginContainer/HBoxContainer/VBoxContainer/quit").connect("pressed", Callable(self, "handleQuit"))


func handleQuit():
	print("Quitting Game")
	get_tree().quit()

func handleResume():
	$PauseMenu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player.is_paused = false

func handleMenu(event):
	if event.is_action_pressed("ui_cancel"):
		# Show Pause Menu
		var visi = not $PauseMenu.visible
		$PauseMenu.visible = visi
		if visi:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			player.is_paused = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			player.is_paused = false



func _input(event: InputEvent) -> void: handleMenu(event)
func _process(delta: float) -> void: pass
