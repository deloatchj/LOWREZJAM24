extends Node

@onready var player = get_tree().get_first_node_in_group("player")
@onready var deathscreen = player.get_node("CanvasLayer/Death")
var player_hp = 8
var keys = []

func _process(_delta):
	if Input.is_key_pressed(KEY_1):
		change_scene("res://Scenes/level1.tscn")
	elif Input.is_key_pressed(KEY_2):
		change_scene("res://Scenes/level2.tscn")
	elif Input.is_key_pressed(KEY_3):
		change_scene("res://Scenes/LevelBoss1.tscn")
	elif Input.is_key_pressed(KEY_4):
		change_scene("res://Scenes/level3.tscn")
	elif Input.is_key_pressed(KEY_5):
		change_scene("res://Scenes/level4.tscn")
	elif Input.is_key_pressed(KEY_6):
		change_scene("res://Scenes/spitter.tscn")
	elif Input.is_key_pressed(KEY_7):
		change_scene("res://Scenes/level5.tscn")
	elif Input.is_key_pressed(KEY_8):
		change_scene("res://Scenes/level6.tscn")
	elif Input.is_key_pressed(KEY_9):
		change_scene("res://Scenes/Pinnacle.tscn")

func change_scene(scene):
	keys.clear()
	if scene is PackedScene:
			get_tree().change_scene_to_packed(scene)
	elif scene is String:
			get_tree().change_scene_to_file(scene)
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player_hp > 8:
		player_hp = 8
	if player_hp < 1:
		die()
	if keys.size() == 1 and player != null:
		player.get_node("CanvasLayer/Control/Key1").visible = true
		player.get_node("CanvasLayer/Control/Key1").modulate = Color.RED
	if keys.size() == 2 and player != null:
		player.get_node("CanvasLayer/Control/Key2").visible = true
		player.get_node("CanvasLayer/Control/Key2").modulate = Color.YELLOW

func die():
	player_hp = 0
	call_deferred("set_death_screen_visibility", true)
	get_tree().paused = true

func set_death_screen_visibility(value):
	if player != null:
		player.get_node("CanvasLayer/Death").visible = value
