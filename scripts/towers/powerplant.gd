extends Tower
class_name PowerPlant

# Power plant

@onready var base = get_tree().get_root().get_node("base")

var counter := 0

func _ready() -> void:
	#Set stats
	level = 0
	_set_stats()
	get_node("upgrade/upgrade").visible = false
	get_node("upgrade/path").visible = false


func _death_effect(enemy: Enemy):
	pass

func _compact(enemy : Enemy):
	if enemy.enemy_class == 0:
		enemy.queue_free()

func _generate_income(value : int):
	base._income(value)

func _process(delta: float) -> void:
	counter+=1
	if counter%6==0:
		_generate_income(1)

func _on_detection_enemy_entered(enemy: Enemy) -> void:
	enemies += 1

func _on_detection_enemy_exited(enemy: Enemy) -> void:
	enemies -= 1

func _on_button_button_down() -> void:
	_upgrade()

func _on_static_body_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if InputEventMouseButton and event.is_action_pressed("select"):
		
		for i in base.get_child_count():
			var child = base.get_child(i)
			if child is Tower and child.name != self.name:
				child.get_node("upgrade/upgrade").hide()
				child.get_node("upgrade/path").hide()
		if level < 2:
			get_node("upgrade/upgrade").visible = !get_node("upgrade/upgrade").visible
		elif level == 2:
			get_node("upgrade/path").visible = !get_node("upgrade/path").visible
		get_node("upgrade/upgrade").global_position = self.global_position + Vector2(-96, 24)
		get_node("upgrade/path").global_position = self.global_position + Vector2(-96, 24)
