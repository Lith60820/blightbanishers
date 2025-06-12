extends CharacterBody2D
class_name Projectile

@export var attack : Attack
@export var speed : int
@export var detection : Detection
@export var retarget : Detection

var target : CharacterBody2D

func _physics_process(delta: float) -> void:
	if target:
		_move()
	else:
		_retarget()

func _retarget():
	var temptargets := retarget.get_overlapping_bodies()
	for i in temptargets:
		if i is Enemy:
			target = i
			return
	queue_free()

func _move():
	var dir : Vector2 = (target.global_position - self.global_position).normalized()
	self.velocity = dir * speed
	move_and_slide()
