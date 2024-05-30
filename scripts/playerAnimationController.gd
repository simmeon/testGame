extends AnimatedSprite2D

enum {UP, DOWN, LEFT, RIGHT}

var lastDir = DOWN

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# get input
	var inputDir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# sanitise input
	inputDir = Vector2(inputDir.x if abs(inputDir.x) > abs(inputDir.y) else 0, \
					   inputDir.y if abs(inputDir.y) > abs(inputDir.x) else 0)
	
	
	if inputDir == Vector2.ZERO:
		# no input, set idle
		setIdleAnimation()
	else:
		# set last dir based on input
		# set walk animation based on input
		if inputDir.x < 0:
			lastDir = LEFT
			play("walk_left")
		elif inputDir.x > 0:
			lastDir = RIGHT
			play("walk_right")
		elif inputDir.y < 0:
			lastDir = UP
			play("walk_up")
		elif inputDir.y > 0:
			lastDir = DOWN
			play("walk_down")

func setIdleAnimation():
	match lastDir:
		UP:
			play("idle_up")
		DOWN: 
			play("idle_down")
		LEFT:
			play("idle_left")
		RIGHT:
			play("idle_right")
