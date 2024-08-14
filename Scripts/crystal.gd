extends CharacterBody3D
@export var hp = .5
@export var teeth_sn : PackedScene
	
func _ready():
	pass # Replace with function body.

func minus_hp(dmg):
	if hp < 1:
		die()
	else:
		hp -= dmg
		
func die():
	$CollisionShape3D.disabled = true
	var teeth = teeth_sn.instantiate()
	teeth.global_transform = global_transform
	teeth.transform.origin.y = 1.1
	teeth.scale = Vector3(5,5,5)
	get_parent().add_child(teeth)
	queue_free()
