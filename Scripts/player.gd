extends CharacterBody3D

@onready var camera: Camera3D = $Camera
@onready var sub_camera: Camera3D = $Camera/SubViewport/sub_camera
@onready var torch: Node3D = $Camera/torch

@onready var crt: ColorRect = $"Camera/2d/crt"

@onready var bar_3: ColorRect = $Camera/Control/container/bar3
@onready var bar_2: ColorRect = $Camera/Control/container/bar2
@onready var bar_1: ColorRect = $Camera/Control/container/bar1

@onready var sub_viewport: SubViewport = $Camera/SubViewport
@onready var maincolor: ColorRect = $Camera/hud/Control/maincolor

@onready var scare: Node3D = $Camera/scare
@onready var anim: AnimationPlayer = $Camera/scare/anim

const SPEED = 1.8

@export var sensitivity := 0.004

var trap_mouse = true
var t_bob = 0.0
var toggle_torch = false
var torch_battery = 100
var move_tolerance = 0.1
var darkness_tolerance = 5
var dark_kill = 4
var already_scared = false


const BOB_FREQ = 5.4
const BOB_AMP = 0.09

@onready var maincolor_2: TextureRect = $Camera/hud/Control/maincolor2

func get_average_color(texture: ViewportTexture,delta) -> Color:
	var image = texture.get_image()
	maincolor_2.texture = texture
	image.resize(1,1,Image.INTERPOLATE_LANCZOS)
	var point = image.get_pixel(0,0)
	if point.get_luminance()==0.0:
		darkness_tolerance-=delta
		print("too dark")
	else:
		darkness_tolerance = 5
		dark_kill = 4
	return image.get_pixel(0,0)

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	trap_mouse = true
	$MeshInstance3D.hide()


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
	
	sub_camera.global_position = camera.global_position
	sub_camera.global_rotation = camera.global_rotation
	maincolor.color = get_average_color(sub_viewport.get_texture(),delta)
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if Glob.staying_still: move_tolerance -=1*delta
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if move_tolerance<=0:
		jumpscare()
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
		
	if Glob.spook:
		jumpscare()
	
	if Glob.staying_still:
		crt.material.set_shader_parameter("noise_amount",0.15)
	else:
		crt.material.set_shader_parameter("noise_amount",0.039)
	
	if darkness_tolerance<=0:
		dark_kill-=delta
	if dark_kill<=0:
		jumpscare()

func jumpscare():
	if not already_scared:
		scare.show()
		anim.play("shake")
		already_scared = true


func _headbob(time: float) -> Vector3:
	var pos := Vector3.ZERO
	pos.y = (sin(time * BOB_FREQ) * BOB_AMP)+1.699
	return pos
