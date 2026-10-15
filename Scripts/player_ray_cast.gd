extends RayCast3D

@onready var character_body_3d: CharacterBody3D = $"../.."
@onready var point: ColorRect = $"../hud/Control/point"

@onready var key_aud: AudioStreamPlayer = $"../../audios/Key"
@onready var cursor_help: Label = $"../hud/cursor_help"
@onready var paper_txt: Label = $"../hud/paper_txt"

var collision_body = null
var scared = false

var txt1 = "He needs your help. get the key from the other end. and then you can open this door."
var txt2 = "Avoid the dark.. He doesnt like it.
If you are cought in a trans, dont move. And always avoid eye contact"

var got_key = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pick"):
				if paper_txt.visible:
					paper_txt.hide()

	if is_colliding():
		if get_collider().name == "tom" and not scared:
			character_body_3d.jumpscare()
			scared = true
		
		if get_collider().is_in_group("pickable"):
			
			collision_body = get_collider()
			point.color = Color(0.0, 1.0, 0.0, 1.0)
			if collision_body.name == "key": cursor_help.text="PICK THE KEY"
			if collision_body.name == "door1": cursor_help.text="OPEN DOOR"
			if collision_body.name == "door2": cursor_help.text="OPEN DOOR"
			if collision_body.name == "paper1": cursor_help.text="READ NOTE"
			if collision_body.name == "paper2": cursor_help.text="READ NOTE"
			cursor_help.show()
			if Input.is_action_just_pressed("pick"):
				if paper_txt.visible:
					paper_txt.hide()
					return
				if collision_body.name == "key":
					key_aud.play()
					collision_body.get_parent().queue_free()
					character_body_3d.holding_key=true
					got_key = true
					
				if collision_body.name == "door2":
					character_body_3d.jumpscare()
					
				if collision_body.name == "door1" and got_key:
					print("WELLCONEEEEEEEEEEEE")
					
				if collision_body.name == "paper1":
					paper_txt.text = txt1
					paper_txt.show()
					
				if collision_body.name == "paper2":
					paper_txt.text = txt2
					paper_txt.show()
		else:
			point.color = Color(0.231, 0.231, 0.231, 0.373)
			cursor_help.hide()
	else:
		point.color = Color(0.231, 0.231, 0.231, 0.373)
		cursor_help.hide()
