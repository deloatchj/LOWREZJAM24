extends Area3D

@export var speed = 10.0
@export var damage = 1

var direction = Vector3.ZERO

func _physics_process(delta):
	if direction != Vector3.ZERO:
		var velocity = direction * speed
		global_transform.origin += velocity * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.minus_health(damage)
		queue_free()
	queue_free()

func _on_timer_timeout():
	queue_free()
