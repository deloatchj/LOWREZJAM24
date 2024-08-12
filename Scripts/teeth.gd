extends Sprite3D

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		if Game.player_hp < 8:
			Game.player_hp += 2
			queue_free()
