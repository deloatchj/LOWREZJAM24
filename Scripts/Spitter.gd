extends CharacterBody3D

var hp = 10
@export var orb_scene : PackedScene
@export var teeth_sn : PackedScene
var muzzle_left : Marker3D
var muzzle_right : Marker3D
var dead = false
@onready var state_machine = $StateMachine

func _ready():
		muzzle_left = $MuzzleLeft
		muzzle_right = $MuzzleRight
		state_machine.start()

func _physics_process(delta):
	var player = get_tree().get_first_node_in_group("player")
	muzzle_left.look_at(player.global_position)
	muzzle_right.look_at(player.global_position)
	if not dead:
		state_machine.process(delta)
	else:
		transform.origin.y = 0

func shoot_orbs():
		var player = get_tree().get_first_node_in_group("player")
		var orb_left = orb_scene.instantiate()
		var orb_right = orb_scene.instantiate()
		orb_left.direction = (player.global_transform.origin - global_transform.origin).normalized()
		orb_right.direction = (player.global_transform.origin - global_transform.origin).normalized()
		get_parent().add_child(orb_left)
		get_parent().add_child(orb_right)
		orb_left.global_position = muzzle_left.global_position
		orb_right.global_position = muzzle_right.global_position

func take_damage(damage):
		if state_machine.current_state.name != "Hide":
				minus_hp(damage)
				if hp % 2 == 0 and hp != 0:
						state_machine.transition_to("Hide")

func player_distance() -> float:
		var player = get_tree().get_first_node_in_group("player")
		if player:
				return global_transform.origin.distance_to(player.global_transform.origin)
		return INF

func minus_hp(dmg):
	if hp <= 0:
		die()
	else:
		var dmg_tween = get_tree().create_tween()
		dmg_tween.tween_property(%Anim, "modulate", Color(1, 0, 0, 1), 0.2)
		dmg_tween.tween_property(%Anim, "modulate", Color(1, 1, 1, 1), 0.2)
		%Hurtsfx.play()
		hp -= dmg

func die():
	dead = true
	%Diesfx.play()
	%Anim.play("die")
	$CollisionShape3D.disabled = true
	var teeth = teeth_sn.instantiate()
	teeth.global_transform = global_transform
	teeth.transform.origin.y = 1.1
	teeth.scale = Vector3(5,5,5)
	get_parent().add_child(teeth)
	get_parent().boss_defeated = true
