extends CharacterBody2D
@export var speed:float = 400.0
	
@export var joystick : Control

func _physics_process(_sdelta: float) -> void:
	if joystick == null:
		return
	velocity = joystick.get_direction() * speed
	move_and_slide()
