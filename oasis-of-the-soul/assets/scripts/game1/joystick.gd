extends Control



var _touch_index: int = -1
var _direction: Vector2 = Vector2.ZERO

@onready var _background: Sprite2D = $Background
@onready var _knob: Sprite2D = $Background/Knob

var radius : float = 50.0



func get_direction() -> Vector2:
	return _direction


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _touch_index == -1:
			if _is_inside_joystick(event.position):
				_touch_index = event.index
				_move_knob(event.position)
		elif not event.pressed and event.index == _touch_index:
			_touch_index = -1
			_reset_knob()
	elif event is InputEventScreenDrag:
		if event.index == _touch_index:
			_move_knob(event.position)


func _is_inside_joystick(pos: Vector2) -> bool:
	return pos.distance_to(_background.global_position) <= radius   # 允许稍大的触摸区域


func _move_knob(touch_pos: Vector2) -> void:
	var offset := touch_pos - _background.global_position
	  # 限制在圆形范围内
	if offset.length() > radius:
		offset = offset.normalized() * radius

	  # 更新 Knob 位置（相对于 Background）
	_knob.position = offset
	_direction = offset / radius


func _reset_knob() -> void:
	_knob.position = Vector2.ZERO
	_direction = Vector2.ZERO
