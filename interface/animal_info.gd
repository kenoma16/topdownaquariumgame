extends WindowDialog

var bar1 = preload("res://assets/progress/10_bar.png")
var bar2 = preload("res://assets/progress/20_bar.png")
var bar3 = preload("res://assets/progress/30_bar.png")
var bar4 = preload("res://assets/progress/40_bar.png")
var bar5 = preload("res://assets/progress/50_bar.png")
var bar6 = preload("res://assets/progress/60_bar.png")
var bar7 = preload("res://assets/progress/70_bar.png")
var bar8 = preload("res://assets/progress/80_bar.png")
var bar9 = preload("res://assets/progress/90_bar.png")

func _ready():
	randomize()

func progress_values(health, thirst, index, hunger, bioscore, age):
	$stats/progress/health.value = health
	$stats/progress/thirst.value = thirst
	$stats/progress/index.value = index
	$stats/progress/hunger.value = hunger
	$stats/progress/bioscore.value = bioscore
	$stats/progress/age.value = age
	progress_colors()

func progress_colors():
	var progress_bars = get_tree().get_nodes_in_group("progress")
	for each in progress_bars:
		if each.value <= 100 and each.value >= 90:
			each.texture_progress = bar9
		elif each.value < 90 and each.value >= 80:
			each.texture_progress = bar8
		elif each.value < 80 and each.value >= 70:
			each.texture_progress = bar7
		elif each.value < 70 and each.value >= 60:
			each.texture_progress = bar6
		elif each.value < 60 and each.value >= 50:
			each.texture_progress = bar5
		elif each.value < 50 and each.value >= 40:
			each.texture_progress = bar4
		elif each.value < 40 and each.value >= 30:
			each.texture_progress = bar3
		elif each.value < 30 and each.value >= 20:
			each.texture_progress = bar2
		else:
			each.texture_progress = bar1
