extends Node2D
class_name Level

@onready var tilemap := self.get_child(0)
@onready var path := self.get_child(2)
const pathfollow = preload("res://pathfollow1.tscn")



func _ready() -> void:
	pass

func _spawn(enemy):
	var _pathfollow = pathfollow.instantiate()
	_pathfollow.add_child(enemy)
	path.add_child(_pathfollow)
