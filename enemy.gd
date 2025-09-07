extends CharacterBody2D
class_name Enemy

@onready var base = get_tree().get_root().get_node("base")

enum TYPES{PLASTIC, ORGANIC, METAL, RADIOACTIVE}

enum CLASS{NORMAL, ELITE, BOSS}

@export var health : Health
@export var speed : int

var move_speed : float

@export var damage : int
@export var enemy_type : TYPES

@export var enemy_class : CLASS

@onready var pathfollow : PathFollow2D = self.get_parent()

const TESTDOT = preload("res://testdot.tres")

var progress

var slow_levels : Array[float] = [0.0,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.0]
var slows : Array[Slow]

var dot_levels : Array[float] = [1,2,3,4,5,6,10,10,10]
var dots : Array[DoT]

func _slow(slow : Slow):
	slows.append(slow)
	slows.sort_custom(_sort_slows)
	await get_tree().create_timer(slow.duration).timeout
	slows.erase(slow)

func _dot(dot : DoT):
	dots.append(dot)
	dots.sort_custom(_sort_dots)
	await get_tree().create_timer(dot.duration).timeout
	dots.erase(dot)

func _ready() -> void:
	move_speed = speed

func _process(delta: float) -> void:
	pathfollow.set_progress(pathfollow.get_progress() + move_speed * delta)
	progress = pathfollow.get_progress()
	
	if slows.size():
		move_speed = slow_levels[slows[0].level] * speed
	else:
		move_speed = speed
	
	if dots.size() and base.counter%6==0:
		self.health._damage(int(dot_levels[dots[0].level]))

func _sort_slows(a : Slow, b : Slow):
	if a.level > b.level:
		return true
	return false

func _sort_dots(a : DoT, b : DoT):
	if a.level > b.level:
		return true
	return false
