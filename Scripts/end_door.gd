extends MeshInstance3D

@export var next_level : PackedScene

func _on_area_3d_body_entered(body):
		if body.is_in_group("player"):
			var tween = create_tween()
			tween.tween_property(self, "position", self.global_position + Vector3(0, -2.1, 0), 2)
			tween.play()
			tween.finished.connect(_on_tween_finished)

func _on_tween_finished():
	if next_level != null:
		Game.change_scene(next_level)
