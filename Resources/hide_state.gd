extends State

var hide_duration = 3.0

func enter():
	%Anim.play("hide")
	$CollisionShape3D.disabled = true
	$Timer.start(hide_duration)

func exit():
	$CollisionShape3D.disabled = false

func _on_Timer_timeout():
	state_machine.transition_to("Idle")
