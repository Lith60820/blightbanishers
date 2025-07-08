extends CanvasLayer
class_name UI

@onready var labels = $LabelManager

# 0 is lives, 1 is energy

func _update(mode : int, value : int):
	match mode:
		0:
			labels._update_lives(value)
		1:
			labels._update_energy(value)
		_:
			print("ERROR when updating label!")
