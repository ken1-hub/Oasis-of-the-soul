extends Control


func _ready() -> void:
	pass 


func _process(_delta: float) -> void:
	pass


func _on_button_1_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/game1/main.tscn")


func _on_button_2_pressed() -> void:
	print("进入游戏2")


func _on_button_return_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/oasis_ui.tscn")


func _on_buttontomeditation_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/scene_meditation_relax.tscn")
