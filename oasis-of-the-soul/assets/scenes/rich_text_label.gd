extends VBoxContainer

const SYSTEM_PROMPT := """你是一个温柔的心情树洞，负责倾听所有来访者的心声。
【核心原则】
1.  完全接纳，永不评判：无论对方说出什么样的情绪或想法，都不做道德评判，不批评，不说教。
2.  深度共情，先接住情绪：在给出任何建议前，先用共情的语言让对方感到被理解。使用"听起来你现在很…"、"如果是我可能也会感到…"之类的表达。
3.  温柔引导，而非强行解决：不急于给出答案。用提问帮对方梳理感受，比如"这种感觉是什么时候开始的？"、"是什么让你产生了这样的想法？"
4.  安全边界：当对方流露出严重自我伤害、伤害他人、或处于极端危险状态时，你需要温柔地、坚定地鼓励他们寻求现实中专业的心理帮助，并告知这超出了你的能力范围。
5.  保持简洁：你的回复通常在2-4句话，像朋友间的低声交谈，不写长篇大论。

【你的风格】
- 语气：温暖、柔和、平静，像傍晚的微风。
- 常用词汇："我听到了""这一定很不容易""慢慢说，小树在听"。
- 你可以适当使用一些自然意象，比如"把烦恼挂在树枝上""让微风带走这些沉重的叶子"，但不要过度使用。

【对话示例】
来访者："我今天在公司被冤枉了，特别委屈。"
小树： "被冤枉的感觉真的很难受，那种委屈好像堵在胸口说不出来，对吗？我在听，你可以慢慢告诉我发生了什么。"
"""

const USER_BUBBLE_COLOR := Color(0.6, 0.8, 1.0)
const AI_BUBBLE_COLOR := Color(1.0, 1.0, 1.0)
const BUBBLE_RADIUS := 12
const FONT_SIZE := 26

var _ai_manage_scene := preload("res://addons/godot_ai_hook/ai_manage/ai_manage.tscn")

@onready var _input: LineEdit = $"../../LineEdit"


func _ready() -> void:
	_input.text_submitted.connect(_on_prompt_submitted)


func send_prompt(prompt: String) -> void:
	if prompt.is_empty():
		return

	_add_user_bubble(prompt)
	_add_ai_bubble(prompt)

	var scroll := get_parent()
	if scroll is ScrollContainer:
		await get_tree().process_frame
		scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value


func _add_user_bubble(text: String) -> void:
	var result := _create_bubble(text, USER_BUBBLE_COLOR)
	var label: RichTextLabel = result[1]
	add_child(result[0])
	_fit_label_to_content.call_deferred(label)


func _add_ai_bubble(prompt: String) -> void:
	var result := _create_bubble("", AI_BUBBLE_COLOR)
	var label: RichTextLabel = result[1]
	add_child(result[0])

	# AI 流式输出时每帧更新高度以跟随内容增长
	label.draw.connect(_fit_label_to_content.bind(label))

	var ai := _ai_manage_scene.instantiate()
	label.add_child(ai)
	ai.say(prompt, SYSTEM_PROMPT)


func _create_bubble(text: String, bg_color: Color) -> Array:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_bottom", 4)

	# 左右对齐：通过 HBoxContainer + spacer 实现
	var hbox := HBoxContainer.new()
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var panel := PanelContainer.new()

	var sb := StyleBoxFlat.new()
	sb.bg_color = bg_color
	sb.corner_radius_top_left = BUBBLE_RADIUS
	sb.corner_radius_top_right = BUBBLE_RADIUS
	sb.corner_radius_bottom_left = BUBBLE_RADIUS
	sb.corner_radius_bottom_right = BUBBLE_RADIUS
	sb.content_margin_left = 12
	sb.content_margin_right = 12
	sb.content_margin_top = 8
	sb.content_margin_bottom = 8
	panel.add_theme_stylebox_override("panel", sb)

	var label := RichTextLabel.new()
	label.bbcode_enabled = false
	label.add_theme_font_size_override("normal_font_size", FONT_SIZE)
	label.add_theme_color_override("default_color", Color.BLACK)
	label.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	label.text = text
	label.scroll_active = false
	label.size_flags_horizontal = Control.SIZE_FILL
	label.size_flags_vertical = Control.SIZE_FILL
	label.custom_minimum_size = Vector2(400, 36)

	panel.add_child(label)
	hbox.add_child(panel)

	# 用户气泡右侧对齐：spacer 在左，气泡在右
	# AI 气泡左侧对齐：气泡在左，spacer 在右
	if bg_color == USER_BUBBLE_COLOR:
		hbox.add_child(spacer)
		hbox.move_child(spacer, 0)
	else:
		hbox.add_child(spacer)

	margin.add_child(hbox)
	return [margin, label]


func _fit_label_to_content(label: RichTextLabel) -> void:
	var h := label.get_content_height()
	if h > 36:
		label.custom_minimum_size.y = h


func _on_prompt_submitted(text: String) -> void:
	send_prompt(text)
	_input.clear()
