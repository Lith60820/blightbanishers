extends TrackTower
class_name Incinerator

# Incinerator

@onready var base : Base = get_tree().get_root().get_node("base")
@export var apply : Area2D

var firing := false

func _ready() -> void:
	#Set stats
	level = 0
	_set_stats()
	get_node("upgrade/upgrade").visible = false
	get_node("upgrade/path").visible = false

@onready var applier := $apply

func _uptime():
	firing = true
	print("FIRING")
	sprite.texture = sprites.textures[4]
	await get_tree().create_timer(self.uptime).timeout
	_downtime()
func _downtime():
	firing = false
	print("DOWN!!!")
	sprite.texture = sprites.textures[level]
	await get_tree().create_timer(self.downtime).timeout
	_uptime()

func _process(delta: float) -> void:
	if base.counter%24 == 0 and firing:
		var enemies = []
		enemies = apply.get_overlapping_bodies()
		for i in enemies:
			if i is not Enemy:
				continue
			self._apply_dot(i)
			print("DOT")

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
		elif level == 2:
			get_node("upgrade/path").visible = !get_node("upgrade/path").visible
		get_node("upgrade/upgrade").global_position = self.global_position + Vector2(-96, 24)
		get_node("upgrade/path").global_position = self.global_position + Vector2(-96, 24)
