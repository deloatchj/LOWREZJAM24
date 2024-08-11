extends MeshInstance3D

@export var door_num : int

var key_colors = {
		1: Color.RED,
		2: Color.YELLOW,
		3: Color.GREEN,
		4: Color.BLUE,
		5: Color.PURPLE,
		6: Color.TEAL,
		7: Color.CADET_BLUE,
		8: Color.CHOCOLATE,
}

func _ready():
	if door_num >= 0 and door_num < key_colors.size():
		var key_color = key_colors[door_num]
		self.set_surface_override_material(0, StandardMaterial3D.new())
		self.get_surface_override_material(0).albedo_color = key_color
		self.get_surface_override_material(0).shading_mode = 0

func _on_area_3d_body_entered(body):
		if body.is_in_group("player"):
				if door_num in Game.keys:
						var tween = create_tween()
						tween.tween_property(self, "position", self.global_position + Vector3(0, -2.1, 0), 2)
						tween.play()
						tween.finished.connect(_on_tween_finished)

func _on_tween_finished():
		queue_free()
