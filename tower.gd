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

@export var sprite : Sprite2D

# UPGRADE PANEL 1

@onready var nameLabel : Label = self.get_node("upgrade/upgrade/name")
@onready var levelLabel : Label = self.get_node("upgrade/upgrade/level")
@onready var upgrade_button : Button = self.get_node("upgrade/upgrade/upgrade")

# UPGRADE PANEL 2 (PATH PANEL)

@onready var nameLabel2 : Label = self.get_node("upgrade/path/name")
@onready var levelLabel2 : Label = self.get_node("upgrade/path/level")
@onready var path1Button : Button = self.get_node("upgrade/path/path1")
@onready var path2Button : Button = self.get_node("upgrade/path/path2")
@onready var path1Cost : Label = self.get_node("upgrade/path/cost1")
@onready var path2Cost : Label = self.get_node("upgrade/path/cost2")

@export var slow_stats : SlowStats

var slow : Slow

@export var doISlow := false

@onready var proj : PackedScene

var canAttack : bool = true

var enemies := 0

func _shoot_projectile(target : Enemy):
	_attack(target,attack)

func _attack(target : Enemy, atk : Attack):
	canAttack = false
	var _bullet = proj.instantiate()
	get_parent().add_child(_bullet)
	_bullet.attack = atk
	_bullet.global_position = self.global_position
	_bullet.homingTarget = target
	_bullet.dir = (target.global_position-self.global_position).normalized()
	_bullet.tower_pos = self.global_position
	await get_tree().create_timer(0.1).timeout
	canAttack = true

func _set_slow():
	slow = slow_stats.slows[level]

func _set_stats():
	attack = stats.attack[level]
	attack_int = stats.attack_int[level]
	if stats.bullets[level] - max_bullets > 0:
		bullets += (stats.bullets[level] - max_bullets)
	max_bullets = stats.bullets[level]
	reload_time = stats.reload_time[level]
	nameLabel.text = stats.tower_names[level]
	nameLabel2.text = stats.tower_names[level]
	levelLabel.text = "Level: " + str(self.level + 1)
	if level == 4:
		levelLabel2.text = "Level: " + str(self.level)
	else:
		levelLabel2.text = "Level: " + str(self.level + 1)
	sprite.texture = sprites.textures[level]

func _upgrade():
	if level < 2 and get_parent()._spend(stats.upgrade_costs[level]):
		level += 1
		_set_stats()
		if doISlow:
			_set_slow()
	if level == 2:
		get_node("upgrade/upgrade").visible = false
		get_node("upgrade/path").visible = true

func _upgrade_path(isFirstPath : bool):
	if isFirstPath:
		# Square Path
		var levelid := 3
		
		if get_parent()._spend(stats.upgrade_costs[levelid]):
			level = 3
			_set_stats()
			if doISlow:
				_set_slow()
	else:
		# Triangle Path
		var levelid := 4
		
		if get_parent()._spend(stats.upgrade_costs[levelid]):
			level = 4
			_set_stats()
			if doISlow:
				_set_slow()

func _ready() -> void:
	pass

# Prioritises furthest enemy

func _sorting(a : Enemy, b : Enemy):
	if a and b:
		if a.progress > b.progress:
			return true
	return false

# Prioritises highest health enemy

func _sorting2(a : Enemy, b : Enemy):
	if a and b:
		if a.health.current_hp > b.health.current_hp:
			return true
	return false
