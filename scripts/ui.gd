extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var menu = $Menu
	# Anchor the menu to the top-right corner
	menu.anchor_left = 1.0   # Anchor left edge to the right of the screen
	menu.anchor_right = 1.0  # Anchor right edge to the right of the screen
	menu.anchor_top = 0.0    # Anchor top edge to the top of the screen
	menu.anchor_bottom = 0.0 # Anchor bottom edge to the top of the screen (no stretch)

	# Adjust offsets for size and position
	menu.offset_left = -100  # Set width of the menu (100px wide)
	menu.offset_right = 0    # Align the right edge with the screen edge
	menu.offset_top = 20     # Add a 20px gap from the top
	menu.offset_bottom = menu.offset_top + 100  # Set height (100px tall)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
