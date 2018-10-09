extends Node

func the_pond():
	get_tree().change_scene("res://pond/pond_1.tscn")
	$label.text = "what"

func aquarium():
	get_tree().change_scene("res://vessels/container.tscn")

func notebook():
	pass # replace with function body

func settings():
	pass # replace with function body

func quit():
	pass # replace with function body
