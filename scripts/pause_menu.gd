extends ColorRect

# Buttons
@onready var resume  : Button = $MarginContainer/HBoxContainer/VBoxContainer/resume as Button
@onready var options : Button = $MarginContainer/HBoxContainer/VBoxContainer/options as Button
@onready var quit    : Button = $MarginContainer/HBoxContainer/VBoxContainer/quit as Button


func _ready() -> void:
	resume.pressed.connect(handleResume)
	options.pressed.connect(handleOptions)
	quit.pressed.connect(handleQuit)

func handleResume():
	print("Closing Pause Menu")
	# get_tree().paused = false
	# self.visible = false

func handleQuit():
	print("Quitting Game")
	get_tree().quit()

func handleOptions():
	print("Opening Options Menu")
