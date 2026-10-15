extends Area3D

@onready var path_follow_3d: PathFollow3D = $".."
@onready var rays: Node3D = $rays

var follow_path = true
var stay_still = false
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow_path:
		path_follow_3d.progress_ratio+=delta*0.013
		
	if get_overlapping_bodies():
		for body in get_overlapping_bodies():
			if body.name == "player":
				Glob.spook = true
		
	
	for ray in rays.get_children():
		if ray.is_colliding():
			if ray.get_collider().is_in_group("player") and not stay_still:
				stay_still = true
				follow_path = false
				Glob.staying_still = true
				await get_tree().create_timer(randf_range(4.0,11.0)).timeout
				follow_path = true
				stay_still = false
				Glob.staying_still = false
				path_follow_3d.progress_ratio+=delta*0.5
			return
			
