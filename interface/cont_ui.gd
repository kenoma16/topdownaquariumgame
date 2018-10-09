extends Control

func _ready():
	$menu_ui/aquarium.hide()
	$menu_ui/pond.connect("pressed", self, "pond")

func pond():
	kill_animals()
	get_tree().change_scene("res://pond/pond_1.tscn")
	
func kill_animals():
	var creatures = get_tree().get_nodes_in_group("animals")
	for each in creatures:
		each.queue_free()
