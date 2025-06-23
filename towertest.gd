extends Tower

#Test Tower

var targets : Array
@export var bullets : int
const BULLET = preload("res://bullet.tscn")
var canAttack : bool = true
var level : int

func _ready() -> void:
	stats.tower_level = 2
	bullets = stats.bullets[stats.tower_level]
	get_node("upgrade/upgrade").visible = false

func _process(delta: float) -> void:
	if bullets and targets.size() and canAttack:
		_attack(targets[0])
		bullets -= 1
		await get_tree().create_timer(stats.reload_time[stats.tower_level]).timeout
		bullets += 1

func _attack(enemy : Enemy):
	canAttack = false
	var _bullet = BULLET.instantiate()
	get_parent().add_child(_bullet)
	_bullet.global_position = self.global_position
	_bullet.target = enemy
	_bullet.attack = stats.attack[stats.tower_level]
	await get_tree().create_timer(stats.attack_int[stats.tower_level]).timeout
	canAttack = true

func _on_detection_enemy_entered(enemy: Enemy) -> void:
	var temptargets := detection.get_overlapping_bodies()
	for i in temptargets:
		if i is Enemy and not targets.has(i):
			targets.append(i)
	print("targets: " + str(targets.size()))

func _on_detection_enemy_exited(enemy: Enemy) -> void:
	if targets.has(enemy):
		targets.erase(enemy)
	print("targets: " + str(targets.size()))


func _on_static_body_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print(placed)
	if InputEventMouseButton and event.button_mask == 1:
		
		if placed:
			get_node("upgrade/upgrade").visible = !get_node("upgrade/upgrade").visible
			get_node("upgrade/upgrade").global_position = self.global_position + Vector2(-96, 24)
		else:
			get_node("upgrade/upgrade").visible = false
