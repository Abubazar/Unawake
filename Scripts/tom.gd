extends Area3D

@onready var path_follow_3d: PathFollow3D = $".."


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path_follow_3d.progress_ratio+=delta*0.008
