extends CharacterBody3D
@export var total_hp = 20
@export var crystals_destroyed = 0
@export var hover_speed = 2
@export var cooldown_reduction = 0.0
@export var teeth_scene :PackedScene
var current_state = "patrol"
var can_damage = false
var hp = 20

func _ready():
	set_physics_process(false)
	patrol()

func _process(delta):
	match current_state:
		"patrol":
			patrol_movement(delta)
		"full_field":
			full_field_attack()
		"focus":
			focus_attack()
		"nudge":
			nudge_player()

func patrol():
	current_state = "patrol"
	set_physics_process(true)
	patrol_movement(0)

func patrol_movement(delta):
	# Circular patrol logic
	rotate_y(hover_speed * delta)
	# Play patrol sound effect, etc.

func roar():
	# Trigger roar sound and effect, stun player
	pass

func full_field_attack():
	current_state = "full_field"
	# Rotate fast and spawn nails
	pass

func focus_attack():
	current_state = "focus"
	# Stop movement and fire nails beam at player
	pass

func nudge_player():
	current_state = "nudge"
	# Land near the player and apply impulse
	pass

func crystal_destroyed():
	crystals_destroyed += 1
	hp -= 2
	if crystals_destroyed % 2 == 0:
		cooldown_reduction += 0.2
		hover_speed = min(hover_speed + 2, 6)

	if crystals_destroyed == 6:
		make_vulnerable()

func make_vulnerable():
	can_damage = true

func on_damage(damage):
	if crystals_destroyed == 6:
		hp -= damage
		if hp <= 8:
			drop_teeth()
			if hp <= 0:
				die()

func drop_teeth():
	var teeth = teeth_scene.instantiate()
	teeth.transform.origin = Vector3(0,1.1,0)
	teeth.scale = Vector3(5,5,5)
	get_parent().add_child(teeth)
	pass

func die():
	queue_free()

func minus_hp(dmg):
	if can_damage:
		if hp < 1:
			die()
		else:
			drop_teeth()
			var dmg_tween = get_tree().create_tween()
			dmg_tween.tween_property(%Anim, "modulate", Color(0, 1, 0, 1), 0.2)
			dmg_tween.tween_property(%Anim, "modulate", Color(1, 1, 1, 1), 0.2)
			%Hurtsfx.play()
			hp -= dmg
