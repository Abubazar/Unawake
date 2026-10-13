extends CharacterBody3D

@onready var camera: Camera3D = $Camera
@onready var torch: Node3D = $Camera/torch

@onready var bar_3: ColorRect = $Camera/Control/container/bar3
@onready var bar_2: ColorRect = $Camera/Control/container/bar2
@onready var bar_1: ColorRect = $Camera/Control/container/bar1


const SPEED = 1.8

@export var sensitivity := 0.004

var trap_mouse = true
var t_bob = 0.0
var toggle_torch = false
var torch_battery = 100


const BOB_FREQ = 5.4
const BOB_AMP = 0.09



func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	trap_mouse = true


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(
			camera.rotation.x,
			deg_to_rad(-40),
			deg_to_rad(40)
		)


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.position = _headbob(t_bob)
	
	if Input.is_action_just_pressed("torch"):
		if torch_battery > 0:
			toggle_torch = not toggle_torch
			if toggle_torch:
				torch.show()
			else:
				torch.hide()
	
	if toggle_torch:
		torch_battery-=0.8*delta
		
	if torch_battery < 68:
		bar_1.hide()
	if torch_battery < 33:
		bar_2.hide()
	if torch_battery <= 0:
		bar_3.hide()
		torch.hide()


func _headbob(time: float) -> Vector3:
	var pos := Vector3.ZERO
	pos.y = (sin(time * BOB_FREQ) * BOB_AMP)+1.699
	return pos
