extends KinematicBody2D

"""
Animal export variables:
all of the relavant shit.
"""
export (Resource) var icon
export (String) var species
export (int) var max_speed
export (float) var rotation_speed
export (int) var max_health
export (int) var max_age
export (float) var min_size
export (float) var max_size

var zindex = 0
var velocity = Vector2()
var alive = true
var being_touched = false
var is_target = false
var wild = true
var selected = false

"""
I decided to put everything the creature
represents into a single dictionary
so they can easily be accessed from the
creature and they look neat in a single
variant. XD
"""
var info = {
	"id": "",
	"name": "",
	"health": {"a": 0, "z": 0, "c": 0},
	"hunger": {"a": 0, "z": 0, "c": 0},
	"thirst": {"a": 0, "z": 0, "c": 0},
	"age": {"a": 0, "z": 0, "c": 0},
	"body_index": {"a": 0, "z": 0, "c": 0},
	"growth": {"a": 0.1, "z": 1.5, "c": 1},
	"metabolism": {"a": 0.1, "z": 1.5, "c": 1},
	"bioscore": {"a": 0, "z": 100, "c": 0}
}

func set_properties():
	info["health"]["z"] = max_health
	info["thirst"]["z"] = max_health / 2
	info["hunger"]["z"] = max_health / 3
	info["body_index"]["a"] = min_size
	info["body_index"]["z"] = max_size
	info["body_index"]["c"] = info["body_index"]["a"]
	info["age"]["z"] = max_age

func _ready():
	randomize()
	set_properties()
	add_to_group("animals")
	add_to_group(species)
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	collision.shape = shape
	collision.shape.radius = $collision.shape.radius * 8
	add_child(area)
	area.add_child(collision)
	zindex = z_index
	$touch.shape = $collision.shape
	$touch.rotation = $collision.rotation
	$touch.position = $collision.position
	
func _physics_process(delta):
	if not alive:
		return
	if being_touched:
		var z = get_tree().get_nodes_in_group("animals").size()
		z_index = z_index + z
		collision_layer = 2
		collision_mask = 2
		global_position = get_global_mouse_position()
	else:
		z_index = zindex
		collision_layer = 1
		collision_mask = 1
		dormant_behavior(delta)
		move_and_slide(velocity)
	$front.collision_mask = collision_mask
	$right.collision_mask = collision_mask
	$left.collision_mask = collision_mask

func dormant_behavior(delta):
	"""
	Essentially, this will be the default behavior
	for any animal.
	"""
	var speed = max_speed
	var rot_dir = 0
	if $left.is_colliding() or $front.is_colliding():
		rot_dir += 1
		speed = 0
	if $right.is_colliding():
		rot_dir -= 1
		speed = 0
	velocity = Vector2()
	rotation += rotation_speed * rot_dir * delta
	velocity += Vector2(speed, 0).rotated(rotation)

func _on_touch_pressed():
	if not being_touched:
		being_touched = true
	if not wild:
		var selecteds = get_tree().get_nodes_in_group("selected")
		if selecteds.size() > 0:
			for each in selecteds:
				each.selected = false
		if not selected:
			selected = true

func _on_touch_released():
	if being_touched:
		being_touched = false

func age():
	"""
	This is connected to the age timer
	and ticks each second. Basically a measurement
	of how long the creature will live.
	"""
	if info["age"]["c"] < info["age"]["z"]:
		info["age"]["c"] += 1
		info["age"]["c"] = clamp(info["age"]["c"], info["age"]["a"], info["age"]["z"])
	else:
		alive = false

func growth():
	"""
	As the functiona name suggests, this represents
	the growth of the creature. The creature will grow not
	only in sprite scale, but also in its properties.
	"""
	var rate = 0.001
	info["health"]["z"] += rate
	info["thirst"]["z"] += rate
	info["hunger"]["z"] += rate
	max_speed += rate

func metabolism():
	"""
	This measures how fast the creature gains or loses
	health, hunger and thirst, and is directly proportional
	to growth. If you have high metabolism, you also
	have high growth, meaning you grow faster. But since you
	have high metabolism, you lose thirst and hunger faster.
	Metabolism and growth is determined in the "Pond", but
	can be manipulated in the "Test Area".
	"""
	var h = "health"
	var t = "thirst"
	var u = "hunger"
	var g = "growth"
	var m = "metabolism"
	var rate = 0.001
	
	info[g]["c"] = clamp(info[g]["c"], info[g]["a"], info[g]["z"])
	info[m]["c"] = clamp(info[m]["c"], info[m]["a"], info[m]["z"])
	info[h]["c"] = clamp(info[h]["c"], info[h]["a"], info[h]["z"])
	info[t]["c"] = clamp(info[t]["c"], info[t]["a"], info[t]["z"])
	info[u]["c"] = clamp(info[u]["c"], info[u]["a"], info[u]["z"])
	
	info[u]["c"] -= info[u]["z"] * 0.002
	info[t]["c"] -= info[t]["z"] * 0.001
	
	$growth.wait_time = info[g]["c"]
	$metabolism.wait_time = info[m]["c"]

	if info[u]["c"] > info[u]["z"] * 0.8 and info[t]["c"] > info[t]["z"] * 0.4 and info[h]["c"] > info[h]["a"]:
		info[g]["c"] += rate
		info[m]["c"] += rate
	else:
		info[g]["c"] -= rate
		info[m]["c"] -= rate

	if info[g]["c"] < 0.5:
		info[m]["c"] -= rate
	else:
		info[m]["c"] += rate
	if info[m]["c"] > 1.1:
		info[g]["c"] -= rate
	else:
		info[g]["c"] += rate
	"""
	This is the part where the roles of the
	metabolism and the growth area clearly seen. 
	As the growth drops, metabolism also drops, 
	which means the creature will lose hunger 
	faster, which makes it more hungry everytime.
	However, if the metabolic rate
	exceeds the norm, the creature also grows faster
	since its body reached the point where
	it can handle low food requirements.
	"""

	if info[u]["c"] == info[u]["a"]:
		info[h]["c"] -= info[h]["z"] * 0.0025
	else:
		info[h]["c"] += info[h]["z"] * 0.0025
	if info[t]["c"] == info[t]["a"]:
		info[h]["c"] -= info[h]["z"] * 0.0050
	else:
		info[h]["c"] += info[h]["z"] * 0.0050

func active_intake(intake):
	"""
	Where INTAKE is an array containing
	the property name that corresponds to
	the info dictionary, the property within
	that property, and the value that should
	be affected.
	Mostly used for food and water
	"""
	if intake.size() > 1:
		info[intake[0]][intake[1]] = intake[2]
	
func passive_intake(intake):
	"""
	where INTAKE is a dictionary of variables
	affecting each of the corresponding properties
	in the "info" dictionary.
	"""
	if intake.size() > 0:
		for each in intake.keys():
			info[each][intake[each][0]] = intake[each][1]