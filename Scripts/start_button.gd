extends Node


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")



func _on_and_pressed() -> void:
	Glob.android = true
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
