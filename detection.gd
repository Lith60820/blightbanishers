extends Area2D
class_name Detection

signal enemy_entered(enemy : Enemy)
signal enemy_exited(enemy : Enemy)

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		enemy_entered.emit(body)

func _on_body_exited(body: Node2D) -> void:
	if body is Enemy:
		enemy_exited.emit(body)
