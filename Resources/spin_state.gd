extends State

var spin_duration = 2.0
var spin_speed = 5.0
var orb_count = 8
var orb_speed = 3.0

func enter():
		$Timer.start(spin_duration)
		spawn_orbs()

func exit():
		$Timer.stop()

func process(delta):
	%Anim.play("atk")
	boss.rotation_degrees.y += spin_speed

func _on_Timer_timeout():
		state_machine.transition_to("Chase")

func spawn_orbs():
		var angle_increment = 2 * PI / orb_count
		for i in range(orb_count):
				boss.shoot_orbs()
				var orb = boss.orb_scene.instantiate()
				boss.add_child(orb)
				var angle = i * angle_increment
				var direction = Vector3(cos(angle), 0, sin(angle))
				orb.global_transform.origin = boss.muzzle_left.global_transform.origin
				orb.speed = 5
				orb.scale = Vector3(1,1,1)
