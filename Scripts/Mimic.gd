extends CharacterBody3D

@onready var anim = %Anim
@export var speed = 1.0
@export var detection_range = 10.0
@export var teeth_sn : PackedScene
@export var hp = 2
@export var nail_scene : PackedScene
@export var shoot_interval = 2.0

@onready var player = get_tree().get_first_node_in_group("player")
var dead = false
@onready var shoot_timer = %ShootTimer

func _physics_process(delta):
	if dead:
		return
	if player != null:
		look_at(player.global_transform.origin)
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		velocity = direction * speed
		move_and_slide()
		

func _process(delta):
	if player == null:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			var closest_player = players[0]
			var closest_distance = global_transform.origin.distance_to(closest_player.global_transform.origin)
			for p in players:
				var distance = global_transform.origin.distance_to(p.global_transform.origin)
				if distance < closest_distance:
					closest_player = p
					closest_distance = distance
			if closest_distance <= detection_range:
				player = closest_player


func die():
	dead = true
	%Diesfx.play()
	%ShootTimer.stop()
	%Anim.play("die")
	$CollisionShape3D.disabled = true
	var teeth = teeth_sn.instantiate()
	teeth.global_transform = global_transform
	teeth.transform.origin.y = 1.1
	teeth.scale = Vector3(5,5,5)
	get_parent().add_child(teeth)

func minus_hp(dmg):
	if hp <= 0:
		die()
	else:
		%Hurtsfx.play()
		hp -= dmg

func shoot_nail():
	%Shootsfx.play()
	var nail = nail_scene.instantiate()
	nail.global_transform = %Marker3D.global_transform
	nail.direction = (player.global_transform.origin - global_transform.origin).normalized()
	get_parent().add_child(nail)

func _on_shoot_timer_timeout():
	shoot_nail()
