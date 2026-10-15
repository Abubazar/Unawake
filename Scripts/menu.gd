extends CanvasLayer

@onready var infomation: Label = $Control/infomation

func _on_exit_btn_pressed() -> void:
	get_tree().quit()

func _on_info_btn_pressed() -> void:
	infomation.show()


func _on_back_btn_pressed() -> void:
	infomation.hide()


func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/maze_map.scn")
