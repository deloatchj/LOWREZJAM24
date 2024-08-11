extends Node3D

func _on_kill_area_body_entered(body):
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
