extends CharacterBody2D

@export var move_speed:float = 180.0
@export var direction_variance : float = 45.0

var move_direction: Vector2
var screen_size:Vector2

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	calculate_movement_direction()
	
	setup_hitbox()
	
func setup_hitbox():
	var hitbox = $Hitbox
	hitbox.add_to_group("enemy_hitbox")
	
func calculate_movement_direction():
	var pos = global_position
	var screen_center = screen_size/2
	
	#计算当前位置相对于屏幕中心的方向
	var base_direction=Vector2.ZERO
	
	if pos.x<screen_center.x:
		base_direction = Vector2.RIGHT
	else:
		base_direction = Vector2.LEFT
		
	if pos.y<screen_center.y:
		base_direction = Vector2.DOWN
	else:
		base_direction = Vector2.UP
		
	#结合水平和垂直方向（加权平均）
	var horizontal_weight = 1.0 - (pos.x/screen_size.x)
	var vertical_weight = 1.0 - (pos.y/screen_size.y)
	
	base_direction = Vector2(
		lerp(-1.0,1.0,horizontal_weight),
		lerp(-1.0,1.0,vertical_weight)
	).normalized()
	
	#添加随机偏移
	var random_rad = deg_to_rad(randf_range(-direction_variance,direction_variance))
	move_direction = base_direction.rotated(random_rad)
	
func _physics_process(_delta: float) -> void:
	velocity = move_direction * move_speed
	move_and_slide()
	
	check_screen_bounds()
	
func check_screen_bounds():
	var margin = 50
	if global_position.x < -margin or global_position.x > screen_size.x + margin or global_position.y < -margin or global_position.y > screen_size.y + margin:
		queue_free()
