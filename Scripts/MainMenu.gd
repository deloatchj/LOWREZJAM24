extends Control

@onready var chaak_button = %Chaak_Button
@onready var jael_button = %Jael_Button
@onready var jerridelo_button = %Jerridelo_Button
@onready var maxi_button = %Maxi_Button

func _ready():
	Game.player_hp = 8
	chaak_button.pressed.connect(chaak_pressed)
	jael_button.pressed.connect(jael_pressed)
	jerridelo_button.pressed.connect(jerridelo_pressed)
	maxi_button.pressed.connect(maxi_pressed)

func _on_play_button_pressed():
	Game.change_scene("res://Scenes/level1.tscn")

func _on_credits_pressed():
	%Credits.visible = true
	%Menu.visible = false

func _on_exit_pressed():
	get_tree().quit()

func _physics_process(delta):
	%Spiral.rotation += delta


func _on_back_pressed():
	%Credits.visible = false
	%Menu.visible = true

func chaak_pressed():
	OS.shell_open("https://chaak-007.itch.io/")

func jael_pressed():
	OS.shell_open("https://chaak-007.itch.io/")

func jerridelo_pressed():
	OS.shell_open("https://chaak-007.itch.io/")

func maxi_pressed():
	OS.shell_open("https://chaak-007.itch.io/")
