extends Node

var animals = {
	"backswimmer": preload("res://animals/species/backswimmer.tscn"),
	"water_boatman": preload("res://animals/species/waterboatman.tscn"),
	"roacklike_stonefly": preload("res://animals/species/roacklike_stonefly.tscn"),
	"giant_stonefly": preload("res://animals/species/giant_stonefly.tscn"),
	"flatworm": preload("res://animals/species/flatworm.tscn"),
	"casemaker_caddisfly": preload("res://animals/species/casemaker_caddisfly.tscn")
	}

func _ready():
	randomize()
	var id = _load("temp_tester")
	var all = _load("temp_container")
	var subject = null
	if all.length() > 0:
		var contained = all.split("||")
		if contained.size() > 0:
			for each in contained:
				var array = each.split("?")
				var subj_id = array[2]
				if subj_id == id:
					subject = array
					break
	if subject:
		var c = animals[subject[0]].instance()
		var stats = subject[3].split("%")
		var health = stats[0].split("#")
		var hunger = stats[1].split("#")
		var thirst = stats[2].split("#")
		var index = stats[3].split("#")
		var age = stats[4].split("#")
		var bioscore = stats[5].split("#")
		var growth = stats[6].split("#")
		var metabolism = stats[7].split("#")
		c.max_health = int(health[1])
		c.max_age = int(age[1])
		c.min_size = int(index[0])
		c.max_size = int(index[1])
		c.set_properties()
		c.wild = false
		c.name = "test_subject"
		c.info["id"] = subject[2]
		c.info["age"]["c"] = int(age[2])
		c.info["health"]["c"] = int(health[2])
		c.info["thirst"]["c"] = int(thirst[2])
		c.info["hunger"]["c"] = int(hunger[2])
		c.info["bioscore"]["c"] = int(bioscore[2])
		c.info["growth"]["c"] = int(growth[2])
		c.info["metabolism"]["c"] = int(metabolism[2])
		c.info["body_index"]["c"] = int(index[2])
		$tester.add_child(c)
		c.global_position = $tester/spawn_point.global_position
		c.global_rotation_degrees = rand_range(0, 359)
	else:
		get_tree().change_scene("res://vessels/container.tscn")
	$menu_ui/pond.connect("pressed", self, "pond")
	$menu_ui/aquarium.connect("pressed", self, "aquarium")

func pond():
	kill_animals()
	get_tree().change_scene("res://pond/pond_1.tscn")

func aquarium():
	kill_animals()
	get_tree().change_scene("res://vessels/container.tscn")

func kill_animals():
	var creatures = get_tree().get_nodes_in_group("animals")
	for each in creatures:
		each.queue_free()

func _load(database):
	var file = File.new()
	file.open("user://" + database + ".dat", file.READ)
	var content = file.get_as_text()
	file.close()
	return content