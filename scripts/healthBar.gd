extends Node2D

var numHearts = 5

@onready var hearts = get_children()

func update_health(health):
	# Clear all hearts
	for heart in hearts:
		heart.play("empty")
	# Fill hearts based on new health
	for heart in hearts.slice(0,health):
		heart.play("full")



func _on_gui_player_health_change(health):
	update_health(health)
