extends CharacterBody3D

var health = 8
var speed = 3.0
var attack_damage = 1
var push_damage = 1
var minion_spawn_interval = 20.0
var push_probability = 0.2  
var scream_probability = 0.02

@onready var player = get_tree().get_first_node_in_group("player")
var freeze_duration = 2.0

@export var orc_scene : PackedScene
@onready var spawn_timer = $SpawnTimer
@onready var attack_area = $AttackArea
@export_color_no_alpha var stun_color
@onready var markerl = get_parent().get_node("MarkerL")
@onready var markerr = get_parent().get_node("MarkerR")

func _ready():
	randomize()

func _physics_process(_delta):
	if player != null:
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		velocity = direction * speed
		move_and_slide()

		var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
		if distance_to_player <= 2.0:
			pass
			#need to add anims here
			#player.minus_health(attack_damage)
		elif distance_to_player < 15.0:
			if randf() > push_probability:
				scream()
			else:
				push_player()


func _on_spawn_timer_timeout():
		var orc1 = orc_scene.instantiate()
		orc1.position = markerl.global_position
		add_child(orc1)
		var orc2 = orc_scene.instantiate()
		orc2.position = markerr.global_position
		add_child(orc2)

func _on_attack_area_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_attack_area_body_exited(body):
	if body.is_in_group("player"):
		player = body

func push_player():
	if player:
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		direction.y = 0  # Set the y component to zero
		player.velocity += direction * 500

func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()

func scream():
	%Anim.modulate = stun_color
	if player != null:
		player.speed = 3
		player.sprint_speed = 7
		await get_tree().create_timer(2).timeout
		player.speed = 5
		player.sprint_speed = 10
