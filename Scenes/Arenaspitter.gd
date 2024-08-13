extends Node3D

var boss_defeated = false

func _physics_process(delta):
	if boss_defeated == true:
		$Barrier/CollisionShape3D.disabled = true
