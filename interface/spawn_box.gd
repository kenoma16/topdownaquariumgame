extends CanvasLayer

var button = preload("res://interface/spawn.tscn")
var animals = [
	preload("res://animals/species/backswimmer.tscn"),
	preload("res://animals/species/waterboatman.tscn"),
	preload("res://animals/species/roacklike_stonefly.tscn"),
	preload("res://animals/species/giant_stonefly.tscn"),
	preload("res://animals/species/flatworm.tscn"),
	preload("res://animals/species/casemaker_caddisfly.tscn")
	]
var showing = false

func _ready():
	$vbox.rect_position = Vector2(103, 150)
	$TextureRect.rect_position = Vector2(80, 129)
	
	for each in animals:
		var b = button.instance()
		var e = each.instance()
		b.picture = e.icon
		b.creature = each
		b.connect("spawn", self, "spawn")
		$vbox.add_child(b)

func _physics_process(delta):
	if not showing:
		$TextureRect.visible = false
		$vbox.visible = false
	else:
		$TextureRect.visible = true
		$vbox.visible = true

func spawn(creature):
	if creature:
		var spawn = creature.instance()
		var pop = get_tree().get_nodes_in_group(spawn.species).size()
		spawn.name = spawn.name + str(pop)
		spawn.being_touched = true
		get_parent().add_child(spawn)
		showing = false