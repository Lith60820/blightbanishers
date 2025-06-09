extends Node
class_name Health

@export var maxhp : int
var current_hp : int

func _ready() -> void:
	current_hp = maxhp

func _damage(value : int):
	current_hp -= value
	if current_hp <= 0:
		get_parent().queue_free()

func _heal(value : int):
	var temphp := current_hp + value
	if temphp > maxhp:
		current_hp = maxhp
	else:
		current_hp = temphp
