extends RayCast3D

@onready var character_body_3d: CharacterBody3D = $"../.."
@onready var point: ColorRect = $"../hud/Control/point"

var collision_body = null

func _process(delta: float) -> void:
	if is_colliding():
		if get_collider().is_in_group("pickable"):
			point.color = Color(0.0, 1.0, 0.0, 1.0)
			if Input.is_action_just_pressed("pick"):
				collision_body = get_collider()
				if collision_body is RigidBody3D:
					collision_body.set_deferred("freeze", true)
		else:
			point.color = Color(0.231, 0.231, 0.231, 0.373)
	else:
		point.color = Color(0.231, 0.231, 0.231, 0.373)
