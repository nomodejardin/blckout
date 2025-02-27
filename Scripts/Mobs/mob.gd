class_name Mob
extends CharacterBody2D


@export_range(0,1000,50) var speed := 50
@export_range(0,1000,50) var health := 100

var direction := Vector2.ZERO

func move():
	velocity = direction * speed
	move_and_slide()

#
#func animate():
	#match direction:
		#Vector2()
	#pass
