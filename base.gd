extends Node2D
class_name Base

@onready var levels : Array[Level] = [preload("res://levels/level_1.tscn").instantiate()]

var laserLocked := false

@onready var level_id = 0

var level : Level
var tilemap : TileMapLayer
var path : Path2D

@export var wave : Waves

@onready var ui = $UI

@export var tower_scene: PackedScene

const DUMMY = preload("res://dummy.tscn")
var occupied := {}

@export var total_lives : int
var current_lives : int

@export var energy_cap : int

var energy : int

var running := true

var counter := 0

var level4s : Array[bool] = [
	# Not level 4
	false,
	# Acid gunner
	false, false,
	# Freeze cannon
	false, false,
	# Compactor
	false, false,
	# Incin
	false, false
]


var enemies : Array[PackedScene] = [
	preload('res://dummy.tscn'),
	preload('res://dummy.tscn'),
	preload('res://enemies/plasticsoldier.tscn'),
	preload('res://enemies/plasticcorporal.tscn'),
	preload('res://enemies/plasticsergeant.tscn'),
	preload('res://enemies/plasticliutenant.tscn')
]

#INITIALISE
#-------------------------------------------------------------------------------------------------------------

func _add_level():
	level = levels[level_id]
	self.add_child(level)
	tilemap = level.tilemap
	path = level.path

func _ready() -> void:
	_add_level()
	current_lives = total_lives
	ui._update(0,current_lives)
	energy = 0
	ui._update(1,energy)
	counter = 0
	_wave(wave)

func _process(delta: float) -> void:
	counter+=1
	if Input.is_action_just_pressed("rc"):
		_spawn_enemy(DUMMY.instantiate())
		running = !running
	if Input.is_action_just_pressed("toggle_lock"):
		laserLocked = !laserLocked
		print(laserLocked)
	if running and counter%60==0:
		counter = 0
		_passive_income()

#TOWER PLACEMENTS
#-------------------------------------------------------------------------------------------------------------

func is_tile_placeable(cell_pos: Vector2i) -> bool:
	var tileData = tilemap.get_cell_tile_data(cell_pos)
	if tileData:
		return tileData.get_custom_data("placeable") and not occupied.has(cell_pos)
	return false

func is_track_placeable(cell_pos: Vector2i) -> bool:
	var tileData = tilemap.get_cell_tile_data(cell_pos)
	if tileData:
		return not tileData.get_custom_data("placeable") and not occupied.has(cell_pos)
	return false

func place_track_tower(tower,pos):
	var cell_pos = tilemap.local_to_map(pos)
	if is_track_placeable(cell_pos) and _spend(tower.stats.cost):
		var world_pos = tilemap.map_to_local(cell_pos)
		tower.position = world_pos
		add_child(tower)
		occupied[cell_pos] = true
		tower.placed = true
		if tower is Incinerator:
			tower._uptime()

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

func _spawn_enemy(enemy : Enemy):
	level._spawn(enemy)

# GET WAVES

func _wave(w : Waves):
	for subwave : Subwaves in w.subwaves:
		_subwave(subwave)

func _subwave(sw : Subwaves):
	await get_tree().create_timer(sw.pause).timeout
	for i in range(sw.enemy_count):
			_spawn_enemy(enemies[sw.enemy_id].instantiate())
			await get_tree().create_timer(sw.spawn_int).timeout

#ENERGY MANAGEMENT
#-------------------------------------------------------------------------------------------------------------

func _income(value : int):
	energy += value
	ui._update(1,energy)

func _set_energy(value : int):
	energy = value
	ui._update(1,energy)

func _passive_income():
	_income(1)

func _spend(value : int) -> bool:
	if energy < value:
		#DOES NOT HAVE ENOUGH
		return false
	else:
		#HAS ENOUGH
		_set_energy(energy-value)
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
