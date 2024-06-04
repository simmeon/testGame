extends Label

var alpha: float
var fontColor = Color(1, 1, 1)
var fontOutlineColor = Color(0, 0, 0)

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
		add_theme_color_override("font_color", Color(fontColor, alpha))
		add_theme_color_override("font_outline_color", Color(fontOutlineColor, alpha))
