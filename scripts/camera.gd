# Copyright © 2017 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Camera

const MOVE_SPEED = 0.25
const MOUSE_SENSITIVITY = 0.002

onready var SettingsGUI = $"../SettingsGUI"
onready var FPSCounter = $"../FPSCounter"

onready var speed = 1
onready var velocity = Vector3()
onready var initial_rotation = self.rotation.y

func _input(event):

	# Mouse look (effective only if the mouse is captured)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Horizontal mouse look
		rotation.y -= event.relative.x*MOUSE_SENSITIVITY
		# Vertical mouse look, clamped to -90..90 degrees
		rotation.x = clamp(rotation.x - event.relative.y*MOUSE_SENSITIVITY, deg2rad(-90), deg2rad(90))

	# Toggle HUD
	if event.is_action_pressed("toggle_hud"):
		FPSCounter.visible = !FPSCounter.visible

	# Toggle mouse capture (only while the menu is not visible)
	if event.is_action_pressed("toggle_mouse_capture") and not SettingsGUI.visible:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	# Speed modifier
	if Input.is_action_pressed("move_speed"):
		speed = 2
	else:
		speed = 1

	# Movement

	if Input.is_action_pressed("move_forward"):
		velocity.x -= MOVE_SPEED*speed*delta

	if Input.is_action_pressed("move_backward"):
		velocity.x += MOVE_SPEED*speed*delta

	if Input.is_action_pressed("move_left"):
		velocity.z += MOVE_SPEED*speed*delta

	if Input.is_action_pressed("move_right"):
		velocity.z -= MOVE_SPEED*speed*delta

	if Input.is_action_pressed("move_up"):
		velocity.y += MOVE_SPEED*speed*delta

	if Input.is_action_pressed("move_down"):
		velocity.y -= MOVE_SPEED*speed*delta

	# Friction
	velocity *= 0.93

	# Apply velocity
	translation += velocity \
	.rotated(Vector3(0, 1, 0), rotation.y - initial_rotation) \
	.rotated(Vector3(1, 0, 0), cos(rotation.y)*rotation.x) \
	.rotated(Vector3(0, 0, 1), -sin(rotation.y)*rotation.x)

func _exit_tree():
	# Restore the mouse cursor upon quitting
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
