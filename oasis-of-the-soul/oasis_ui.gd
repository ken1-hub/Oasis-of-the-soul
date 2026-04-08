extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_meditation_relax_pressed() -> void:
	print("正在进入冥想模块...") 
	get_tree().change_scene_to_file("res://scene_meditation_relax.tscn")# Replace with function body.


func _on_button_small_game_pressed() -> void:
	print("正在进入压力释放模块...")
	get_tree().change_scene_to_file("res://scene_stress_release.tscn") # Replace with function body.
