extends Tower

#Acid gunner

var targets : Array
const BULLET = preload("res://bullet.tscn")
var canAttack : bool = true
@onready var levelLabel : Label = $upgrade/upgrade/HBoxContainer/level
@onready var button = $upgrade/upgrade/HBoxContainer/Button

func _set_stats():
	attack = stats.attack[level]
	attack_int = stats.attack_int[level]
	bullets = stats.bullets[level]
	reload_time = stats.reload_time[level]
	
	print("New attack:", attack.damage)

func _ready() -> void:
	
	#Set stats
	level = 0
	_set_stats()
	
	get_node("upgrade/upgrade").visible = false
	levelLabel.text = "Level " + str(level + 1)

func _process(delta: float) -> void:
	if targets.size():
		look_at(targets[0].global_position)
		if bullets and canAttack:
			_attack(targets[0])
			bullets -= 1
			await get_tree().create_timer(1).timeout
			bullets += 1
		
	
	#Turn towards target

func _attack(enemy : Enemy):
	canAttack = false
	var _bullet = BULLET.instantiate()
	get_parent().add_child(_bullet)
	_bullet.global_position = self.global_position
	_bullet.target = enemy
	await get_tree().create_timer(0.1).timeout
	canAttack = true

func _on_detection_enemy_entered(enemy: Enemy) -> void:
	var temptargets := detection.get_overlapping_bodies()
	for i in temptargets:
		if i is Enemy and not targets.has(i):
			targets.append(i)

func _on_detection_enemy_exited(enemy: Enemy) -> void:
	if targets.has(enemy):
		targets.erase(enemy)

func _upgrade():
	if level < 2 and get_parent()._spend(stats.upgrade_costs[level]):
		level += 1
		_set_stats()
	levelLabel.text = "Level " + str(level + 1)
	

func _on_button_button_down() -> void:
	_upgrade()

func _on_static_body_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if InputEventMouseButton and event.button_mask == 1:
		var path = get_tree().get_root().get_node("base")
		for i in path.get_child_count():
			var child = path.get_child(i)
			if child is Tower and child.name != self.name:
				child.get_node("upgrade/upgrade").hide()
		get_node("upgrade/upgrade").visible = !get_node("upgrade/upgrade").visible
		get_node("upgrade/upgrade").global_position = self.global_position + Vector2(-96, 24)
