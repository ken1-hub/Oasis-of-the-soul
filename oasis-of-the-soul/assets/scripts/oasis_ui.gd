extends Control


func _ready() -> void:
	pass



func _process(delta: float) -> void:
	pass


func _on_button_meditation_relax_pressed() -> void:
	print("正在进入冥想模块...") 
	get_tree().change_scene_to_file("res://assets/scenes/scene_meditation_relax.tscn")


func _on_button_small_game_pressed() -> void:
	print("正在进入压力释放模块...")
	get_tree().change_scene_to_file("res://assets/scenes/scene_stress_release.tscn")
