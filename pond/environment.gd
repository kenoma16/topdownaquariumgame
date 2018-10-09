extends Node

var animals = [
	preload("res://animals/species/backswimmer.tscn"),
	preload("res://animals/species/waterboatman.tscn"),
	preload("res://animals/species/roacklike_stonefly.tscn"),
	preload("res://animals/species/giant_stonefly.tscn"),
	preload("res://animals/species/flatworm.tscn"),
	preload("res://animals/species/casemaker_caddisfly.tscn")
		]
export (bool) var can_spawn
export (float) var time_interval
export (int) var capacity

func _ready():
	randomize()
	if can_spawn:
		$spawn.wait_time = time_interval
		$spawn.start()

func _on_spawn_timeout():
	var total = get_tree().get_nodes_in_group("animals").size()
	if can_spawn and total <= capacity:
		var spawn = animals[randi() % animals.size()].instance()
		var pop = get_tree().get_nodes_in_group(spawn.species).size()
		var spas = get_tree().get_nodes_in_group("spawner")
		var spa = spas[randi() % spas.size()]
		spawn.info["id"] = str(randi() % 999999 + spas.size())
		spawn.max_health = randi() % 25 + 10
		spawn.max_age = randi() % 2000 + 500
		spawn.set_properties()
		spawn.info["age"]["c"] = randi() % spawn.max_age
		spawn.info["health"]["c"] = randi() % spawn.info["health"]["z"]
		spawn.info["thirst"]["c"] = randi() % spawn.info["thirst"]["z"]
		spawn.info["hunger"]["c"] = randi() % spawn.info["hunger"]["z"]
		spawn.info["bioscore"]["c"] = randi() % 100
		spawn.info["growth"]["c"] = rand_range(spawn.info["growth"]["a"], spawn.info["growth"]["z"])
		spawn.info["metabolism"]["c"] = rand_range(spawn.info["metabolism"]["a"], spawn.info["metabolism"]["z"])
		spawn.min_size = rand_range(0.5, 1)
		spawn.max_size = spawn.min_size * 1.5
		spawn.global_rotation = spa.global_rotation
		spawn.global_position = spa.global_position
		spawn.name = spawn.name + str(pop)
		spawn.z_as_relative = false
		$spawners.add_child(spawn)
