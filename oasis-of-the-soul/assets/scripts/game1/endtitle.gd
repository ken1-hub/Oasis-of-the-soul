extends CanvasLayer

@onready var score_label = $UIPanel/ScoreLabel
@onready var restart_button = $UIPanel/RestartButton
@onready var quit_button = $UIPanel/QuitButton

func _ready() -> void:
	#初始隐藏
	visible = false
	
	#确保按钮焦点
	restart_button.focus_mode = Control.FOCUS_ALL
	quit_button.focus_mode = Control.FOCUS_ALL
	
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
func show_game_over(final_score:int):
	score_label.text = str(final_score) + "秒"
	visible = true
	get_tree().paused = true
	
	#设置按钮焦点
	restart_button.grab_focus()

func hide_game_over():
	visible = false
	get_tree().paused = false



func _on_restart_button_pressed() -> void:
	hide_game_over()
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().paused = false  # 先取消暂停
	get_tree().change_scene_to_file("res://assets/scenes/scene_stress_release.tscn")
