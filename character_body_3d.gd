extends CharacterBody3D

@onready var path_follow_3d: PathFollow3D = $".."

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	path_follow_3d.progress_ratio+=delta*0.1
	move_and_slide()
