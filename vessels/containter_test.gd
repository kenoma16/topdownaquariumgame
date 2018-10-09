extends Node2D

var contained = {}
var contained_animals = []

func _physics_process(delta):
	z_index = get_tree().get_nodes_in_group("animals").size() + 1

func _on_inside_body_entered(body):
	if not contained.has(body.name) and not contained_animals.has(body):
		contained_animals.append(body)
		contained[body.name] = []
		body.collision_layer = 2
		body.collision_mask = 2

func _on_inside_body_exited(body):
	if contained.has(body.name) and contained_animals.has(body):
		body.collision_layer = 1
		body.collision_mask = 1
		contained.erase(body.name)
		contained_animals.remove(contained_animals.find(body))