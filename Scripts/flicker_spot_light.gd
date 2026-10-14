extends SpotLight3D


var random_wait = 0
var counting = false

func toggle_light():
	light_energy = 0.06
	await get_tree().create_timer(0.01).timeout
	light_energy = 0.3
	

func tim2(sec):
	await get_tree().create_timer(sec).timeout
	flicker()

func flicker():
	toggle_light()
	var rand = randf_range(0.1,0.9)
	if rand > 0.6:
		counting = false
		light_energy = 0.3
		return
	tim2(rand)
	

func ontime(sec):
	counting = true
	await get_tree().create_timer(sec).timeout
	
	flicker()


func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not counting:
		random_wait = randf_range(1, 5)
		ontime(random_wait)
