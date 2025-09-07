extends Panel
class_name UITrackTower

var tower : PackedScene

func _on_gui_input(event: InputEvent) -> void:
	var _tower = tower.instantiate()
	if event is InputEventMouseButton and event.button_mask == 1:
		_tower.global_position = get_global_mouse_position()
		add_child(_tower)
		get_child(1).process_mode = Node.PROCESS_MODE_DISABLED
		get_child(1).scale = Vector2(0.32,0.32)
	elif event is InputEventMouseMotion and event.button_mask == 1:
		get_child(1).global_position = get_global_mouse_position()
	elif event is InputEventMouseButton and event.button_mask == 0:
		if get_child_count() > 1:
			get_child(1).queue_free()
		get_parent().get_parent().get_parent().get_parent().place_track_tower(tower.instantiate(),get_global_mouse_position())
