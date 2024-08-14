extends CharacterBody3D

var dead = false
var player = null
var can_move = true
@export var speed = 5.0
@export var detection_range = 10.0
@export_color_no_alpha var stun_color

func _on_ImmobileTimer_timeout():
	%Anim.play("die")
	if player != null:
		player.set_process(true)
		player.set_physics_process(true)
		player = null
	queue_free()

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		can_move = false
		player = body
		%Anim.modulate = stun_color
		player.set_process(false)
		player.set_physics_process(false)
		player.minus_health(2)
		%StunSound.play()
		$ImmobileTimer.start(2)

func _physics_process(delta):
	if dead:
		return
	if player != null and can_move:
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
	%Anim.play("die")
	$Area3D/CollisionShape3D.disabled = true
	$CollisionShape3D.disabled = true

func minus_hp(hp):
	dead = true
	%Anim.play("die")
	$Area3D/CollisionShape3D.disabled = true
	$CollisionShape3D.disabled = true

func _on_anim_animation_finished():
	queue_free()
