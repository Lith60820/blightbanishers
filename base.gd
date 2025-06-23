extends Node2D
class_name Base

@onready var level = $level
@onready var tilemap = $level/tilemap
@onready var path = $level/path
@export var tower_scene: PackedScene

const DUMMY = preload("res://dummy.tscn")
var occupied := {}

@export var total_lives : int
var current_lives : int

@export var energy_cap : int

var energy : int

#INITIALISE

func _ready() -> void:
	current_lives = total_lives
	energy = 30


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
	if is_tile_placeable(cell_pos) and _spend(tower.stats.cost):
		var world_pos = tilemap.map_to_local(cell_pos)
		tower.position = world_pos
		add_child(tower)
		print("PLACED " + str(occupied.size()))
		occupied[cell_pos] = true
		tower.placed = true

#ENEMY SPAWNING
#-------------------------------------------------------------------------------------------------------------

func _spawn_enemy(enemy : Enemy):
	level._spawn(enemy)

#ECONOMY MANAGEMENT
#-------------------------------------------------------------------------------------------------------------

func _spend(value : int) -> bool:
	if energy < value:
		#DOES NOT HAVE ENOUGH
		return false
	else:
		#HAS ENOUGH
		energy-=value
		return true

#LIVES
#-------------------------------------------------------------------------------------------------------------

func _on_killzone_body_entered(body: Node2D) -> void:
	if body is Enemy:
		print(_damage(body.damage))
		body.queue_free()

func _damage(value : int) -> int:
	current_lives-=value
	if current_lives <= 0:
		#GAME OVER
		current_lives = 0
		print("DEAD")
	if current_lives > total_lives:
		current_lives = total_lives
	return current_lives
