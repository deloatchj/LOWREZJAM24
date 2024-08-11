extends Sprite3D

@export var key_num : int

var key_colors = {
		1: Color.RED,
		2: Color.YELLOW,
		3: Color.GREEN,
		4: Color.BLUE,
		5: Color.PURPLE,
		6: Color.TEAL,
		7: Color.CADET_BLUE,
		8: Color.CHOCOLATE,
}

func _ready():
	if key_num >= 0 and key_num < key_colors.size():
		var key_color = key_colors[key_num]
		modulate = key_color

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		Game.keys.append(key_num)
		queue_free()
