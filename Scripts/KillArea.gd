extends Area3D

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.get_node("CanvasLayer/Death").visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
