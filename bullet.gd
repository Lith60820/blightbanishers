extends Projectile

func _on_detection_enemy_entered(enemy: Enemy) -> void:
	var temptargets = detection.get_overlapping_bodies()
	for i in temptargets:
		if i is not Enemy:
			temptargets.erase(i)
			continue
		i.health._damage(attack.damage)
		self.queue_free()
		break
	self.queue_free()
