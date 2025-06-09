extends Node2D
class_name Base

@onready var level = $level
@onready var tilemap = $level/tilemap
@onready var path = $level/path
@export var tower_scene: PackedScene

const DUMMY = preload("res://dummy.tscn")
var occupied := {}

#TOWER PLACEMENTS
#-------------------------------------------------------------------------------------------------------------

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("rc"):
		print("AAA")
		_spawn_enemy(DUMMY.instantiate())


func is_tile_placeable(cell_pos: Vector2i) -> bool:
	var tileData = tilemap.get_cell_tile_data(cell_pos)
	if tileData:
		return tileData.get_custom_data("placeable") and not occupied.has(cell_pos)
	return false

func place_tower(pos):
	var cell_pos = tilemap.local_to_map(pos)
	var tower = tower_scene.instantiate()
	if is_tile_placeable(cell_pos):
		var world_pos = tilemap.map_to_local(cell_pos)
		tower.position = world_pos
		add_child(tower)
		print("PLACED " + str(occupied.size()))
		occupied[cell_pos] = true

#ENEMY SPAWNING
#-------------------------------------------------------------------------------------------------------------

func _spawn_enemy(enemy : Enemy):
	level._spawn(enemy)

#ECONOMY MANAGEMENT
#-------------------------------------------------------------------------------------------------------------

#LIVES
#-------------------------------------------------------------------------------------------------------------
