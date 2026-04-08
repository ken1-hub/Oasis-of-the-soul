extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_1_pressed() -> void:
	print("进入游戏1") # Replace with function body.


func _on_button_2_pressed() -> void:
	print("进入游戏2") # Replace with function body.


func _on_button_return_pressed() -> void:
	get_tree().change_scene_to_file("res://oasis_ui.tscn") # Replace with function body.
