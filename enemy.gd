extends CharacterBody2D
class_name Enemy

enum TYPES{PLASTIC, ORGANIC, METAL, RADIOACTIVE}

@export var health : Health
@export var speed : int

var move_speed : float

@export var damage : int
@export var enemy_type : TYPES

@onready var pathfollow : PathFollow2D = self.get_parent()

var progress

var slow_levels : Array[float] = [0.0,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.0]
var slows : Array[Slow]

func _slow(slow : Slow):
	slows.append(slow)
	slows.sort_custom(_sorting)
	await get_tree().create_timer(slow.duration).timeout
	slows.erase(slow)

func _ready() -> void:
	move_speed = speed

func _process(delta: float) -> void:
	pathfollow.set_progress(pathfollow.get_progress() + move_speed * delta)
	progress = pathfollow.get_progress()
	
	if slows.size():
		move_speed = slow_levels[slows[0].level] * speed
	else:
		move_speed = speed

func _sorting(a : Slow, b : Slow):
	if a.level > b.level:
		return true
	return false
