extends Button

signal spawn

var creature
var picture

func _ready():
	if picture:
		icon = picture

func _on_spawn_pressed():
	if creature:
		emit_signal("spawn", creature)
