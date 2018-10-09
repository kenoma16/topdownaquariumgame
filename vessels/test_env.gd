extends Node

var box = preload("res://interface/spawn_box.tscn")

func show_spawn_panel():
	if has_node("spawn_box"):
		get_node("spawn_box").queue_free()
	else:
		var b = box.instance()
		b.name = "spawn_box"
		b.showing = true
		add_child(b)