extends Projectile

func _on_detection_enemy_entered(enemy: Enemy) -> void:
	_damage()
