extends Control


func _ready() -> void:
	pass



func _process(_delta: float) -> void:
	pass





func _on_emotiontreehole_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/emotion_treehole.tscn")


func _on_meditation_relax_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/scene_meditation_relax.tscn")


func _on_stress_release_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/scene_stress_release.tscn")
