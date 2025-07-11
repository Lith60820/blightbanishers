extends Projectile
class_name Slower

func _on_detection_enemy_entered(enemy: Enemy) -> void:
	_damage()
