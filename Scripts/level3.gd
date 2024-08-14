extends Node3D

func _ready():
	await get_tree().create_timer(3).timeout
	$NEWunlock.visible = false


