extends CharacterBody2D

var direction = Vector2.LEFT
var speed = 100

func _process(delta: float) -> void:
	position += direction * speed * delta
