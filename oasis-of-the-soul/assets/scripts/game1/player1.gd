extends CharacterBody2D
@export var speed:float = 400.0
@export var joystick : Control

var score : int = 0
var is_dead : bool = false

signal hit_enemy

@onready var game_over_ui = preload("res://assets/scenes/game1/endtitle.tscn")

func _physics_process(_sdelta: float) -> void:
	if joystick == null:
		return
	velocity = joystick.get_direction() * speed
	move_and_slide()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hitbox"):
		hit_enemy.emit()
