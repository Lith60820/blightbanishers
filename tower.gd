extends Node2D
class_name Tower

@export var sprites : Sprites

@export var tower_name : String
@export var detection : Detection
@export var stats : TowerStats

# Stat variables:

var level : int
var attack : Attack
var attack_int : float
var max_bullets : int
var bullets : int
var reload_time : float

var placed : bool = false

func _ready() -> void:
	self.stats.tower_level

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_mask == 0:
		print("UP2")
