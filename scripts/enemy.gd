extends Area2D

signal damagePlayer(damageAmount, position)

@export var damageAmount = 1
@export var speed = 100

var isPlayerDashing = false
var g_delta = 0.0
var damageLabel = preload("res://scenes/damageLabel.tscn")
var damageText = ["OUCHIE", "OOF", "FUCK", "OH NO"]
var rng = RandomNumberGenerator.new()

func _ready():
	$AnimatedSprite2D.play()
	$NavigationAgent2D.max_speed = speed

func _process(delta):
	isPlayerDashing = PlayerInfo.isDashing
	
	$NavigationAgent2D.target_position = PlayerInfo.position
	var nextPathPos = $NavigationAgent2D.get_next_path_position()
	var velocity = position.direction_to(nextPathPos) * speed
	$NavigationAgent2D.velocity = velocity
	g_delta = delta
	

func _on_body_entered(_body):
	if isPlayerDashing:
		$AnimatedSprite2D.hide()
		$GPUParticles2D.restart()
		$CollisionShape2D.queue_free()
		var instantiatedDamageLabel = damageLabel.instantiate()
		instantiatedDamageLabel.text = damageText[ rng.randi() % damageText.size() ]
		instantiatedDamageLabel.fontColor = Color(1, 0.3, 0.3)
		add_child(instantiatedDamageLabel)
	else:
		damagePlayer.emit(damageAmount, position)


func _on_gpu_particles_2d_finished():
	queue_free()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if $AnimatedSprite2D.visible:
		position += safe_velocity * g_delta
