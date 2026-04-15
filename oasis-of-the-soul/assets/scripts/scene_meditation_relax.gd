extends Control

func _ready() -> void:
	pass



func _process(delta: float) -> void:
	pass


func _on_button_return_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/oasis_ui.tscn")


func _on_buttontostress_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/scene_stress_release.tscn")
