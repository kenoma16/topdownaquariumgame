extends Control

var target = null

func _ready():
	$capture/capture.connect("pressed", self, "capture")
	$capture/throw.connect("pressed", self, "throw")
	$menu_ui/pond.hide()
	$menu_ui/aquarium.connect("pressed", self, "aquarium")

func aquarium():
	kill_animals()
	get_tree().change_scene("res://vessels/container.tscn")

func kill_animals():
	var creatures = get_tree().get_nodes_in_group("animals")
	for each in creatures:
		each.queue_free()

func capture_area(body):
	body.is_target = true
	target = body
	$capture/animal.texture = body.icon
	$capture/species_name.text = body.species.capitalize()
	$capture.show()

func _physics_process(delta):
	update_env_ui()

func _append(content):
	var old_data = str(_load())
	var new_data = ""
	if old_data.length() == 0:
		new_data = content
	else:
		new_data = "||" + content
	_save(old_data + new_data)

func _save(content):
	var file = File.new()
	file.open("user://temp_container.dat", file.WRITE)
	file.store_string(content)
	file.close()

func _load():
	var file = File.new()
	file.open("user://temp_container.dat", file.READ)
	var content = file.get_as_text()
	file.close()
	return content

func update_env_ui():
	if target:
		if target.is_queued_for_deletion():
			target = null
		else:
			var health = target.info["health"]["c"] * 100 / target.info["health"]["z"]
			var hunger = target.info["hunger"]["c"] * 100 / target.info["hunger"]["z"]
			var thirst = target.info["thirst"]["c"] * 100 / target.info["thirst"]["z"]
			var index = target.info["body_index"]["c"] * 100 / target.info["body_index"]["a"] - target.info["body_index"]["z"]
			var age = target.info["age"]["c"] * 100 / target.info["age"]["z"]
			var bioscore = target.info["bioscore"]["c"] * 100 / target.info["bioscore"]["z"]
			$capture.progress_values(int(health), int(thirst), int(index), int(hunger), int(bioscore), int(age))

func capture():
	if target:
		if target.is_queued_for_deletion():
			target = null
		else:
			var dt = OS.get_datetime()
			var full = ""
			for each in dt.keys():
				if each != "dst":
					if full == "":
						full = str(dt[each])
					else:
						full = full + "/" + str(dt[each])
			var health = ""
			var hunger = ""
			var thirst = ""
			var index = ""
			var age = ""
			var bioscore = ""
			var metabolism = ""
			var growth = ""
			var other = ""
			for each in target.info["metabolism"].keys():
				if metabolism == "":
					metabolism = str(target.info["metabolism"][each])
				else:
					metabolism = metabolism + "#" +  str(target.info["metabolism"][each])
			for each in target.info["growth"].keys():
				if growth == "":
					growth = str(target.info["growth"][each])
				else:
					growth = growth + "#" +  str(target.info["growth"][each])
			for each in target.info["health"].keys():
				if health == "":
					health = str(target.info["health"][each])
				else:
					health = health + "#" +  str(target.info["health"][each])
			for each in target.info["hunger"].keys():
				if hunger == "":
					hunger = str(target.info["hunger"][each])
				else:
					hunger = hunger + "#" +  str(target.info["hunger"][each])
			for each in target.info["thirst"].keys():
				if thirst == "":
					thirst = str(target.info["thirst"][each])
				else:
					thirst = thirst + "#" +  str(target.info["thirst"][each])
			for each in target.info["body_index"].keys():
				if index == "":
					index = str(target.info["body_index"][each])
				else:
					index = index + "#" +  str(target.info["body_index"][each])
			for each in target.info["age"].keys():
				if age == "":
					age = str(target.info["age"][each])
				else:
					age = age + "#" +  str(target.info["age"][each])
			for each in target.info["bioscore"].keys():
				if bioscore == "":
					bioscore = str(target.info["bioscore"][each])
				else:
					bioscore = bioscore + "#" +  str(target.info["bioscore"][each])
			other = health + "%" + hunger + "%" + thirst + "%" + index + "%" + age + "%" + bioscore + "%" + growth + "%" + metabolism
			_append(target.species + "?" + full + "?" + target.info["id"] + "?" + other)
			target.queue_free()
	$capture.hide()

func throw():
	$capture.hide()