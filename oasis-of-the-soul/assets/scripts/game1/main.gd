extends Node2D

var enemy_scene: PackedScene = preload("res://assets/scenes/game1/enemies.tscn")

@onready var player1 = $player1
@onready var game_over_ui = preload("res://assets/scenes/game1/endtitle.tscn")


func _on_enemytimer_timeout() -> void:
	var enemy = enemy_scene.instantiate() as CharacterBody2D
	var pos_maker = $Enemystartposition.get_children().pick_random() as Marker2D
	enemy.position = pos_maker.position
	$Enemies.add_child(enemy)

func _on_player_1_hit_enemy() -> void:
	game_over()


	
func game_over() -> void:
	get_tree().paused = true
	
	var ui_instance = game_over_ui.instantiate()
	add_child(ui_instance)
	ui_instance.show_game_over(score)
	
	
var score : int = 0

func _on_score_timer_timeout() -> void:
	score +=1
