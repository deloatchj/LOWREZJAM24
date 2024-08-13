extends State

var chase_speed = 4.0
var walk_speed = 2.0
var fly_height = 1.0

func process(delta):
	%Anim.play("walk")
	if boss.is_on_floor():
		var direction = Vector3.ZERO
		direction.x = randf() * 2 - 1
		direction.z = randf() * 2 - 1
		direction = direction.normalized()
		boss.velocity.x = direction.x * walk_speed
		boss.velocity.z = direction.z * walk_speed
		boss.velocity.y = 0
	else:
		var direction = Vector3.ZERO
		direction.x = randf() * 2 - 1
		direction.z = randf() * 2 - 1
		direction = direction.normalized()
		
		boss.velocity.x = direction.x * chase_speed
		boss.velocity.z = direction.z * chase_speed
		boss.transform.origin.y = 2.5
	if randf() > 0.5:
		boss.shoot_orbs()
	boss.move_and_slide()
	
	if boss.player_distance() > 20:
			boss.transform.origin.y = 0.0
			state_machine.transition_to("Spin")
	elif boss.player_distance() <= 10:
			boss.transform.origin.y = 0.0
			state_machine.transition_to("Idle")

