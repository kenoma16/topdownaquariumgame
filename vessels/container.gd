extends Node

var target = null

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
	var database = _load()
	if not database.empty():
		var contained = database.split("||")
		if contained.size() > 0:
			for each in contained:
				each = each.split("?")
				var species = each[0]
				var id = each[2]
				var stats = each[3].split("%")
				var health = stats[0].split("#")
				var hunger = stats[1].split("#")
				var thirst = stats[2].split("#")
				var index = stats[3].split("#")
				var age = stats[4].split("#")
				var bioscore = stats[5].split("#")
				var growth = stats[6].split("#")
				var metabolism = stats[7].split("#")
				var c = animals[species].instance()
				var pos = $aquarium.global_position
				var dis = 2
				c.info["id"] = id
				c.max_health = int(health[1]) # This is health "z" or max
				c.max_age = int(age[1])
				c.set_properties()
				c.info["age"]["c"] = int(age[2])
				c.info["health"]["c"] = int(health[2])
				c.info["thirst"]["c"] = int(thirst[2])
				c.info["hunger"]["c"] = int(hunger[2])
				c.info["bioscore"]["c"] = int(bioscore[2])
				c.info["growth"]["c"] = int(growth[2])
				c.info["metabolism"]["c"] = int(metabolism[2])
				c.min_size = int(index[0])
				c.max_size = int(index[1])
				c.info["body_index"]["c"] = int(index[2])
				c.wild = false
				c.global_position = Vector2(rand_range(pos.x/dis,pos.x*dis),
			rand_range(pos.y/dis,pos.y*dis))
				c.global_rotation_degrees = rand_range(0, 359)
				$spawns.add_child(c)

func _load():
	var file = File.new()
	file.open("user://temp_container.dat", file.READ)
	var content = file.get_as_text()
	file.close()
	return content

func _on_test_body_entered(body):
	if body.has_method("dormant_behavior"):
		$confirmation.dialog_text = "Are you sure you want to\ntest this " + body.species.capitalize() + "?"
		$confirmation.show()
		target = body

func _on_confirmation_confirmed():
	if target:
		var file = File.new()
		file.open("user://temp_tester.dat", file.WRITE)
		file.store_string(target.info["id"])
		file.close()
		target = null
		get_tree().change_scene("res://vessels/test_area.tscn")

func _on_test2_pressed():
	get_tree().change_scene("res://vessels/test_area.tscn")
