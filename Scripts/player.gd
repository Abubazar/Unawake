extends CharacterBody3D

@onready var camera: Camera3D = $Camera
@onready var sub_camera: Camera3D = $Camera/SubViewport/sub_camera
@onready var torch: Node3D = $Camera/torch

@onready var crt: ColorRect = $"Camera/2d/crt"

@onready var bar_3: ColorRect = $Camera/Control/container/bar3
@onready var bar_2: ColorRect = $Camera/Control/container/bar2
@onready var bar_1: ColorRect = $Camera/Control/container/bar1

@onready var sub_viewport: SubViewport = $Camera/SubViewport

@onready var scare: Node3D = $Camera/scare
@onready var anim: AnimationPlayer = $Camera/scare/anim



@onready var torch_aud: AudioStreamPlayer = $audios/Torch
@onready var kill_screech: AudioStreamPlayer = $audios/KillScreech
@onready var stay_still: AudioStreamPlayer = $audios/StayStill
@onready var heartbeat: AudioStreamPlayer = $audios/Heartbeat
@onready var lstep: AudioStreamPlayer = $audios/Lstep
@onready var rstep: AudioStreamPlayer = $audios/Rstep
@onready var fear: AudioStreamPlayer = $audios/fear


const SPEED = 2

@export var sensitivity := 0.004

var trap_mouse = true
var t_bob = 0.0
var toggle_torch = false
var torch_battery = 100
var move_tolerance = 0.1
var move_tol_cd = false
var darkness_tolerance = 3
var dark_kill = 2
var already_scared = false
var histol = false

var holding_key = false

const BOB_FREQ = 5.4
const BOB_AMP = 0.09

@onready var maincolor_2: TextureRect = $Camera/hud/Control/maincolor2

func get_average_color(texture: ViewportTexture,delta):
	var image = texture.get_image()
	maincolor_2.texture = texture
	image.resize(1,1,Image.INTERPOLATE_LANCZOS)
	var point = image.get_pixel(0,0)
	if point.get_luminance()==0.0:
		darkness_tolerance-=delta
	else:
		darkness_tolerance = 3
		dark_kill = 2
		if fear.playing: fear.stop()

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
	get_average_color(sub_viewport.get_texture(),delta)
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	footsteps(direction)
	if direction:
		if Glob.staying_still and move_tol_cd: move_tolerance -=1*delta
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
		torch_aud.play()
		if torch_battery > 0:
			toggle_torch = not toggle_torch
			if toggle_torch:
				torch.show()
			else:
				torch.hide()
	
	if toggle_torch:
		torch_battery-=2.5*delta
		
	if torch_battery < 68:
		bar_1.hide()
	if torch_battery < 33:
		bar_2.hide()
	if torch_battery <= 0:
		bar_3.hide()
		torch.hide()
		
	if Glob.spook:
		jumpscare()
	
	if Glob.staying_still and not histol:
		histol = true
		await get_tree().create_timer(1).timeout
		move_tol_cd = true
	
	if Glob.staying_still:
		crt.material.set_shader_parameter("noise_amount",0.15)
		if not stay_still.playing:
			stay_still.play()
			
	else:
		if stay_still.playing:
			stay_still.stop()
		crt.material.set_shader_parameter("noise_amount",0.039)
		move_tol_cd = false
		histol = false
	
	if darkness_tolerance<=0:
		dark_kill-=delta
		if not fear.playing:
			fear.play()
	if dark_kill<=0:
		jumpscare()

func jumpscare():
	if not already_scared:
		kill_screech.play()
		scare.show()
		anim.play("shake")
		already_scared = true


func _headbob(time: float) -> Vector3:
	var pos := Vector3.ZERO
	pos.y = (sin(time * BOB_FREQ) * BOB_AMP)+1.699
	return pos



var last_step="l"
func footsteps(walking):
	if not walking:
		return
	if last_step=="l":
		if not rstep.playing and not lstep.playing:
			rstep.play()
			last_step="r"
	else:
		if not lstep.playing and not rstep.playing:
			lstep.play()
			last_step="l"
		
