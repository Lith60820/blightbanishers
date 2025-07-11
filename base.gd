extends Node2D
class_name Base

@onready var levels : Array[Level] = [preload("res://levels/level_1.tscn").instantiate()]

@onready var level_id = 0

var level : Level
var tilemap : TileMapLayer
var path : Path2D

@onready var ui = $UI

@export var tower_scene: PackedScene

const DUMMY = preload("res://dummy.tscn")
var occupied := {}

@export var total_lives : int
var current_lives : int

@export var energy_cap : int

var energy : int

var running:=false

var counter := 0

#INITIALISE

func _add_level():
	level = levels[level_id]
	self.add_child(level)
	tilemap = level.tilemap
	path = level.path

func _ready() -> void:
	_add_level()
	current_lives = total_lives
	ui._update(0,current_lives)
	energy = 200
	ui._update(1,energy)
	counter = 0


#TOWER PLACEMENTS
#-------------------------------------------------------------------------------------------------------------

func _process(delta: float) -> void:
	counter+=1
	if Input.is_action_just_pressed("rc"):
		_spawn_enemy(DUMMY.instantiate())
		running = !running
	if running and counter%6==0:
		_passive_income()


func is_tile_placeable(cell_pos: Vector2i) -> bool:
	var tileData = tilemap.get_cell_tile_data(cell_pos)
	if tileData:
		return tileData.get_custom_data("placeable") and not occupied.has(cell_pos)
	return false

func place_tower(tower,pos):
	var cell_pos = tilemap.local_to_map(pos)
	if is_tile_placeable(cell_pos) and _spend(tower.stats.cost):
		var world_pos = tilemap.map_to_local(cell_pos)
		tower.position = world_pos
		add_child(tower)
		occupied[cell_pos] = true
		tower.placed = true

#ENEMY SPAWNING
#-------------------------------------------------------------------------------------------------------------

# GET WAVES

func _spawn_enemy(enemy : Enemy):
	level._spawn(enemy)

#ENERGY MANAGEMENT
#-------------------------------------------------------------------------------------------------------------

func _energy(value : int):
	energy = value
	ui._update(1,value)

func _passive_income():
	_energy(energy + 1)

func _spend(value : int) -> bool:
	if energy < value:
		#DOES NOT HAVE ENOUGH
		return false
	else:
		#HAS ENOUGH
		_energy(energy-value)
		return true



#LIVES
#-------------------------------------------------------------------------------------------------------------

func _on_killzone_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.queue_free()
		_damage(body.damage)

func _damage(value : int) -> int:
	current_lives-=value
	if current_lives <= 0:
		#GAME OVER
		current_lives = 0
	if current_lives > total_lives:
		current_lives = total_lives
	ui._update(0,current_lives)
	return current_lives
