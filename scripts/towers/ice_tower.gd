extends Tower
class_name Ice

func _slow_projectile(target : Enemy):
	canAttack = false
	var _bullet : Slower = proj.instantiate()
	get_parent().add_child(_bullet)
	_bullet.slow = self.slow
	print(_bullet.slow.level)
	_bullet.attack = self.attack
	_bullet.global_position = self.global_position
	_bullet.tower_pos = self.global_position
	_bullet.target = target.global_position
	
	_bullet.destDis = self.global_position.distance_to(target.global_position)
	
	_bullet.dir = (target.global_position - self.global_position).normalized()
	
	await get_tree().create_timer(0.1).timeout
	canAttack = true

func _ready() -> void:
	#Set stats
	level = 0
	_set_stats()
	_set_slow()
	proj = preload("res://projectiles/snowball.tscn")
	get_node("upgrade/upgrade").visible = false
	get_node("upgrade/path").visible = false

func _process(delta: float) -> void:
	if enemies:
		var my_enemies = []
				
		for i in detection.get_overlapping_bodies():
			if i is Enemy:
				my_enemies.append(i)
			
		my_enemies.sort_custom(_sorting)
		#Turn towards target
		look_at(my_enemies[0].global_position)
		if bullets and canAttack:
			_slow_projectile(my_enemies[0])
			bullets -= 1
			await get_tree().create_timer(reload_time).timeout
			bullets += 1

func _on_detection_enemy_entered(enemy: Enemy) -> void:
	enemies += 1

func _on_detection_enemy_exited(enemy: Enemy) -> void:
	enemies -= 1

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
	if not get_tree().get_root().get_node("base").level4s[3] and level == 2:
		_upgrade_path(true)
		get_tree().get_root().get_node("base").level4s[3] = true


func _on_path_2_button_down() -> void:
	if not get_tree().get_root().get_node("base").level4s[4] and level == 2:
		_upgrade_path(false)
		get_tree().get_root().get_node("base").level4s[4] = true
