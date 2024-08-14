extends Node3D

var orclord_defeated = false

func _on_kill_area_body_entered(body):
	if body.is_in_group("player"):
		body.get_node("CanvasLayer/Death").visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true

func _process(delta):
	if orclord_defeated == true and Game.melee_unlocked == true:
		await get_tree().create_timer(2).timeout
		Game.change_scene("res://Scenes/level3.tscn")
