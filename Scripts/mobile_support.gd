extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_torch_pressed() -> void:
	Input.action_press("torch")
	Input.action_release("torch")


func _on_pick_pressed() -> void:
	Input.action_press("pick")
	Input.action_release("pick")
