extends CSGBox3D

enum GunMode {REVOLVER, SHOTGUN, ASSAULT_RIFLE, MELEE}
@export var ritualmode : GunMode
var unentered = true
var revolvertext = preload("res://Sprites/ritualrevolver.png")
var shotguntext = preload("res://Sprites/ritualshotgun.png")
var assaulttext = preload("res://Sprites/ritualassault.png")
var new_anim

func _process(delta):
	%Sprite3D.rotation.y += delta

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		if body.current_gun_mode == GunMode.MELEE:
			body.prev_gun_mode = ritualmode
			body.current_gun_mode = ritualmode
		elif body.prev_gun_mode != GunMode.MELEE:
			body.prev_gun_mode = GunMode.MELEE
			body.current_gun_mode = ritualmode
		body.hand.play(new_anim)
		if unentered == true:
			Game.player_hp += 1
			unentered = false

func _ready():
	match ritualmode:
		GunMode.REVOLVER:
			%GunSprite.texture = revolvertext
			new_anim = "idle_r"
		GunMode.SHOTGUN:
			%GunSprite.texture = shotguntext
			new_anim = "idle_sh"
		GunMode.ASSAULT_RIFLE:
			%GunSprite.texture = assaulttext
			new_anim = "idle_ar"
