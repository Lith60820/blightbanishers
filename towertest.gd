extends Tower

var targets : Array
@export var bullets : int
const BULLET = preload("res://bullet.tscn")
var canAttack : bool = true

func _ready() -> void:
	bullets

func _process(delta: float) -> void:
	if bullets and targets.size() and canAttack:
		_attack(targets[0])
		bullets -= 1
		await get_tree().create_timer(1).timeout
		bullets += 1

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
	print("targets: " + str(targets.size()))

func _on_detection_enemy_exited(enemy: Enemy) -> void:
	if targets.has(enemy):
		targets.erase(enemy)
	print("targets: " + str(targets.size()))
