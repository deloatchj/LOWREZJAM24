@tool
extends Label3D

func _process(_delta):
	if Engine.is_editor_hint():
		if "Door" in get_parent().name:
			text = str("Door: ", get_parent().door_num)
		if "Key" in get_parent().name:
			text = str("Key: ", get_parent().key_num)
	else:
		visible = false

