extends Label

var alpha: float

# Called when the node enters the scene tree for the first time.
func _ready():
	alpha = 1.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += 20 * Vector2.UP * delta
	alpha -= 0.02
	if alpha < 0.05:
		queue_free()
	else:
		add_theme_color_override("font_color", Color(1, 1, 1, alpha))
		add_theme_color_override("font_outline_color", Color(0, 0, 0, alpha))
