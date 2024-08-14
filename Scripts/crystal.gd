extends CharacterBody3D
@export var hp = 1
@export var teeth_sn : PackedScene
@onready var boss = get_tree().get_first_node_in_group("boss")

func minus_hp(dmg):
	if hp < 1:
		die()
	else:
		var dmg_tween = get_tree().create_tween()
		dmg_tween.tween_property(%Anim, "modulate", Color(1, 1, 0, 1), 0.2)
		dmg_tween.tween_property(%Anim, "modulate", Color(1, 1, 1, 1), 0.2)
		hp -= dmg
		
func die():
	$CollisionShape3D.disabled = true
	var teeth = teeth_sn.instantiate()
	teeth.global_transform = global_transform
	teeth.transform.origin.y = 1.1
	teeth.scale = Vector3(5,5,5)
	get_parent().add_child(teeth)
	boss.crystal_destroyed()
	queue_free()

func _process(delta):
	%Cage.rotation += Vector3(delta,delta,delta)
	%Cage.rotation += Vector3(delta,delta,delta)
