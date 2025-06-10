extends CharacterBody2D
class_name Projectile

@export var attack : Attack
@export var speed : int

var target : CharacterBody2D

func _physics_process(delta: float) -> void:
	var dir : Vector2 = (self.global_position - target.global_position).normalized()
	self.velocity = dir * speed
