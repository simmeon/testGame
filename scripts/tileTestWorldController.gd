extends Node2D

signal damagePlayer(damageAmount:float)

var enemy = preload("res://scenes/enemy.tscn")
var rng = RandomNumberGenerator.new()

@onready var enemySpawnLocations = $Enemies/SpawnLocations.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_enemy_spawn_timer_timeout():
	var enemyInstance = enemy.instantiate()
	enemyInstance.position = enemySpawnLocations[ rng.randi_range(0, len(enemySpawnLocations) - 1) ].position
	#enemyInstance.damageAmount = rng.randi_range(1, 3) # just testing it works
	$Enemies.add_child(enemyInstance)
	enemyInstance.damagePlayer.connect(_on_damage_player)


func _on_damage_player(damageAmount, position):
	damagePlayer.emit(damageAmount, position)
