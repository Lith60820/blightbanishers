extends Tower
class_name Acid

var temp : Sprite2D

func _ready() -> void:
	#Set stats
	level = 0
	_set_stats()
	proj = preload("res://projectiles/bullet.tscn")
	get_node("upgrade/upgrade").visible = false
	get_node("upgrade/path").visible = false
	

func _laser(target: Vector2):
	pass
	

func _process(delta: float) -> void:
	if level == 3:
			_laser(get_global_mouse_position())
			look_at(get_global_mouse_position())
	elif targets.size():
		#Turn towards target
		look_at(targets[0].global_position)
		if bullets and canAttack and level != 3:
			_shoot_projectile(targets[0])
			bullets -= 1
			await get_tree().create_timer(1).timeout
			bullets += 1
	

func _on_detection_enemy_entered(enemy: Enemy) -> void:
	var temptargets := detection.get_overlapping_bodies()
	for i in temptargets:
		if i is Enemy and not targets.has(i):
			targets.append(i)
	targets.sort_custom(_sorting)

func _on_detection_enemy_exited(enemy: Enemy) -> void:
	if targets.has(enemy):
		targets.erase(enemy)

func _on_button_button_down() -> void:
	_upgrade()

func _on_static_body_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if InputEventMouseButton and event.is_action_pressed("select"):
		var path = get_tree().get_root().get_node("base")
		for i in path.get_child_count():
			var child = path.get_child(i)
			if child is Tower and child.name != self.name:
				child.get_node("upgrade/upgrade").hide()
				child.get_node("upgrade/path").hide()
		if level < 2:
			get_node("upgrade/upgrade").visible = !get_node("upgrade/upgrade").visible
		elif level >= 2:
			get_node("upgrade/path").visible = !get_node("upgrade/path").visible
		get_node("upgrade/upgrade").global_position = self.global_position + Vector2(-96, 24)
		get_node("upgrade/path").global_position = self.global_position + Vector2(-96, 24)

func _on_path_1_button_down() -> void:
	_upgrade_path(true)

func _on_path_2_button_down() -> void:
	_upgrade_path(false)
