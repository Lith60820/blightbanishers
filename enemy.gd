extends CharacterBody2D
class_name Enemy

@export var health : Health
@export var speed : int
@export var damage : int

enum TYPES{PLASTIC, ORGANIC, METAL, RADIOACTIVE}

@export var enemy_type : TYPES


@onready var pathfollow : PathFollow2D = self.get_parent()

func _process(delta: float) -> void:
	pathfollow.set_progress(pathfollow.get_progress() + speed * delta)
