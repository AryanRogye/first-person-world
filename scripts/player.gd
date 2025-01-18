extends CharacterBody3D

# Mesh Related
@onready var mesh_look:Node3D = $"Mesh Look"
@onready var mesh:MeshInstance3D = $"normal-man-a/Skeleton3D/Mesh"
@onready var animations:AnimationPlayer = $AnimationPlayer
# Camera
@onready var camera_holder:Node3D = $"CameraHolder"
@onready var camera_raycast:RayCast3D = $"CameraHolder/RayCast3D"
@onready var camera:Camera3D = $"CameraHolder/RayCast3D/Camera3D"

# Drive Label Parts
@onready var driveBox : ColorRect = $"CameraHolder/RayCast3D/Camera3D/CanvasLayer/ColorRect"
@onready var driveLabel : Label = $"CameraHolder/RayCast3D/Camera3D/CanvasLayer/ColorRect/Car Indicator"

@onready var speed = 1.0
@onready var walk_speed = 2.0
@export var run_speed = 4.0
@export var jump_velocity = 5.0
@export var look_sensitivity = 0.01

# Tracking If Idle Is Running or not
var isIdlePlaying = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng = RandomNumberGenerator.new()
var rand = 0

var driving_car:VehicleBody3D
var detected_car:VehicleBody3D

var is_paused = false


func _ready() -> void:
	# allow the player to rotate the character
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	animations.connect("animation_finished", Callable(self, "_on_animation_finished"))
	rng.randomize()

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["YawnIdleN", "HappyIdleN", "IdleN"]:
		isIdlePlaying = false

func _input(event):
	if is_paused:
		return
	if event is InputEventMouseMotion:
		camera_holder.rotate_y(event.relative.x * -look_sensitivity)
		camera_raycast.rotate_x(event.relative.y * look_sensitivity)
		camera_raycast.rotation.x = clamp(camera_raycast.rotation.x, -PI/4, PI/4)

func _process(delta: float) -> void:
	if is_paused:
		return
	if Input.is_action_just_pressed("enter"):
		if driving_car:
			position = driving_car.player_exit.global_position
			driving_car.toggle_player()
			detected_car = driving_car
			driving_car = null
			camera.current = true
		elif detected_car:
			position.y = -100
			mesh.position = position - Vector3(0, 0.05, 0)
			velocity = Vector3.ZERO
			driving_car = detected_car
			detected_car = null
			camera.current = false
			driving_car.toggle_player()
			driveBox.hide()
			driveLabel.hide()

	if Input.is_action_pressed("run"):
		speed = run_speed
	else:
		speed = walk_speed

	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back").normalized() * speed
	velocity = input.x * -camera_holder.global_basis.x + input.y * -camera_holder.global_basis.z + Vector3(0, velocity.y, 0)

	# Handle animation based on input and velocity
	if input.length() > 0:  # If there's movement input
		isIdlePlaying = false
		mesh_look.look_at(position - Vector3(velocity.x, 0, velocity.z))
		if velocity.y == 0:
			if speed == walk_speed:
				animations.play("WalkN")
			else:
				animations.play("RunN")
	elif velocity.y == 0 and not isIdlePlaying:
		isIdlePlaying = true
		rand = rng.randi_range(0, 10)
		print(rand)
		# Create a random number from 0 to 10
		# We Will Assign 0 and 1 to yarn and happy
		match rand:
			0:
				animations.play("YawnIdleN")
			1:
				animations.play("HappyIdleN")
			_:
				animations.play("IdleN")

	# Handle rotation
	mesh.rotation.z = lerp_angle(mesh.rotation.z, mesh_look.rotation.y, delta * 5)

	# Handle jumping and falling
	if is_on_floor():
		animations.playback_default_blend_time = 1
		animations.speed_scale = 1
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = jump_velocity
			animations.play("JumpN")
	else:
		velocity.y -= gravity * delta
		animations.playback_default_blend_time = 0.5
		animations.speed_scale = 1.3

	# Handle movement and camera logic
	move_and_slide()
	if camera_raycast.is_colliding():
		camera.global_position = camera_raycast.get_collision_point()
	else:
		camera.position = Vector3(0, 0, -2)
	camera.position.z -= 0.1
	mesh.position = position - Vector3(0, 0.05, 0)

func _on_car_detector_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if driving_car: return
	detected_car = body
	driveBox.show()
	driveLabel.show()

func _on_car_detector_body_shape_exited(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if driving_car: return
	detected_car = null
	driveBox.hide()
	driveLabel.hide()
