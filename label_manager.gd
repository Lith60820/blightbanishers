extends Node
class_name LabelManager

@onready var lives : Label = $lives
@onready var energy : Label = $energy

func _update_lives(amt : int):
	lives.text = "Lives: " + str(amt)

func _update_energy(amt : int):
	energy.text = "Energy: " + str(amt)
