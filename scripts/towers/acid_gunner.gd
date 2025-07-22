extends Tower
class_name Acid

var temp : Sprite2D

var locked := false

var laserTarget : Vector2 = Vector2.RIGHT


func _ready() -> void:
	#Set stats
	level = 0
	_set_stats()
	proj = preload("res://projectiles/bullet.tscn")
	get_node("upgrade/upgrade").visible = false
	get_node("upgrade/path").visible = false
	

@onready var laser_line := $LaserLine
const laser_length := 5000

func _laser(target: Vector2,tick : int):
	
	var from = global_position
	var direction = (target - from).normalized()
	var to = from + direction * laser_length

	laser_line.clear_points()
	laser_line.add_point(to_local(from))
	laser_line.add_point(to_local(to))
	laser_line.width = 16
	laser_line.default_color = Color.RED
	
	if tick%6!=0:
		return
	var results = $laserArea.get_overlapping_bodies()
	
	for i in results:
		if i is Enemy:
			i.health._damage(self.attack.damage)
	
	
var counter := 0

func _process(delta: float) -> void:
	counter+=1
	if level == 3:
			_laser(laserTarget,counter)
			if not get_tree().get_root().get_node("base").laserLocked:
				laserTarget = get_global_mouse_position()
				look_at(laserTarget)
	elif enemies:
		if bullets and canAttack and level != 3:
			if level == 4:
				var my_enemies = []
				
				for i in detection.get_overlapping_bodies():
					if i is Enemy:
						my_enemies.append(i)
				
				my_enemies.sort_custom(_sorting2)
				
				var pattack := self.attack
				pattack.damage = max(my_enemies[0].health.current_hp * 0.1,10)
				
				#Turn towards target
				look_at(my_enemies[0].global_position)
				
				_attack(my_enemies[0],pattack)
				print(pattack.damage)
				bullets -= 1
				await get_tree().create_timer(1).timeout
				bullets += 1
			else:
				var my_enemies = []
				
				for i in detection.get_overlapping_bodies():
					if i is Enemy:
						my_enemies.append(i)
				
				my_enemies.sort_custom(_sorting)
				
				#Turn towards target
				look_at(my_enemies[0].global_position)
				
				_shoot_projectile(my_enemies[0])
				bullets -= 1
				await get_tree().create_timer(1).timeout
				bullets += 1
	if counter%99 == 0:
		counter = 0
		

func _on_detection_enemy_entered(enemy: Enemy) -> void:
	#var temptargets := detection.get_overlapping_bodies()
	#for i in temptargets:
		#if i is Enemy and not targets.has(i):
			#targets.append(i)
	#
	#if level == 4:
		#targets.sort_custom(_sorting2)
	#else:
		#targets.sort_custom(_sorting)
	enemies += 1

func _on_detection_enemy_exited(enemy: Enemy) -> void:
	#if targets.has(enemy):
		#targets.erase(enemy)
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
	if not get_tree().get_root().get_node("base").level4s[1] and level == 2:
		_upgrade_path(true)
		get_tree().get_root().get_node("base").level4s[1] = true

func _on_path_2_button_down() -> void:
	if not get_tree().get_root().get_node("base").level4s[2] and level == 2:
		_upgrade_path(false)
		get_tree().get_root().get_node("base").level4s[2] = true


func _on_upgrade_button_down() -> void:
	pass # Replace with function body.
