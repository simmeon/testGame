extends CharacterBody2D

signal healthChange(health)
signal invincibleStart

@export var playerSpeed = 100
@export var dashSpeed = 1000
@export var dashTime = 0.15
@export var health = 5
@export var knockbackSpeed = 200
@export var knockbackTime = 0.3

const INPUT_THRESHOLD = 0.1

var isDashing = false
var dashDir = Vector2.ZERO
var invincible = false
var inputAllowed = true
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	
	# `velocity` will be a Vector2 between `Vector2(-1.0, -1.0)` and `Vector2(1.0, 1.0)`.
	# This handles deadzone in a correct way for most use cases.
	# The resulting deadzone will have a circular shape as it generally should.
	if inputAllowed:
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
		# Deal with weird small incorrect values when using keyboard
		if absf(velocity.x) < INPUT_THRESHOLD:
			velocity.x = 0
		if absf(velocity.y) < INPUT_THRESHOLD:
			velocity.y = 0
	
		# Regular velocity
		velocity = velocity * playerSpeed
	
	# Dash
	if Input.is_action_just_pressed("dash") and not isDashing and \
		velocity != Vector2.ZERO and inputAllowed:
		
		isDashing = true
		PlayerInfo.isDashing = true
		$DashTimer.start(dashTime)
		dashDir = velocity.normalized()
		scale.y /= 2
		$GPUParticles2D.emitting = true
	if isDashing:
		velocity = dashDir * dashSpeed
	
	# Update player position
	move_and_slide()
	PlayerInfo.position = position


func _on_dash_timer_timeout():
	isDashing = false
	PlayerInfo.isDashing = false
	scale.y *= 2
	$GPUParticles2D.emitting = false


func _on_damage_player(damageAmount:float, sourcePosition:Vector2):
	# Damage health if not invincible
	if not invincible:
		health -= damageAmount
	if health < 0:
		health = 0
	healthChange.emit(health)
	
	# Start knockback if not invincible
	if not invincible:
		$KnockbackTimer.start(knockbackTime)	
		$InvincibleTimer.start()
		invincible = true
		invincibleStart.emit()
		inputAllowed = false
		var vDirection = position - sourcePosition
		velocity = vDirection.normalized() * knockbackSpeed

func _on_knockback_timer_timeout():
	inputAllowed = true
	velocity = Vector2.ZERO


func _on_invincible_timer_timeout():
	invincible = false
