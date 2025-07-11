extends CharacterBody2D
class_name Projectile

@export var attack : Attack
@export var speed : int
@export var detection : Detection
@export var retarget : Detection

@export var freeze : Detection

var target : CharacterBody2D
var enemy_detected := false

@export var doISlow := false
var slow : Slow

func _damage():
	enemy_detected = true
	var temptargets = detection.get_overlapping_bodies()
	for i in temptargets:
		if i is not Enemy:
			temptargets.erase(i)
			continue
		if i is Enemy:
			i.health._damage(attack.damage)
			if doISlow:
				var freezetargets = freeze.get_overlapping_bodies()
				
				for f in freezetargets:
					if f is Enemy:
						f._slow(slow)
		self.queue_free()

func _physics_process(delta: float) -> void:
	if target:
		_move()
	else:
		_retarget()
	
	if enemy_detected:
		_damage()

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
