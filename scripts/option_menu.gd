extends ColorRect

@onready var animation_text = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/SliderHBox/VBoxContainer/TextEdit
@onready var animation_slider : HSlider = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/SliderHBox/VBoxContainer/HBoxContainer/HSlider
@onready var back_button : Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/BackHBox/BackButton
@onready var animator : AnimationPlayer = $AnimationPlayer

signal request_pause_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	var pause_menu = parent.get_node("PauseMenu")

	if pause_menu is not ColorRect:
		print("PauseMenu is null")
		return

	# Connect the signal to the function
	pause_menu.connect("request_options_screen", Callable(self, "showOptionScreen"))

	var slider : HSlider
	if animation_slider is HSlider:
		slider = animation_slider
		slider.min_value = 0
		slider.max_value = Globals.max_animation_time
		slider.value = 600
		slider.connect("value_changed", Callable(self, "_on_animation_slider_value_changed"))
	back_button.pressed.connect(handleBackButton)

func handleBackButton():
	var parent = get_parent()
	var pause_menu = parent.get_node("PauseMenu")
	self.hideOptionScreen()
	emit_signal("request_pause_menu")
	if pause_menu.has_method("pause"):
		pause_menu.pause()
	else:
		print("PauseMenu has no method pause")
func _on_animation_slider_value_changed(value: float) -> void:
	Globals.max_animation_time = value
	animation_text.text = str(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animation_text.text = str("Animation Time:", Globals.max_animation_time)

func showOptionScreen():
	print("Show Option Screen Called")
	self.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func hideOptionScreen():
	self.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
