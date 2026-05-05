extends Panel

@onready var player = $AudioPlayer
@onready var seek_bar = $SeekBar
@onready var time_label = $TimeLabel

var is_dragging = false

func _ready():
	seek_bar.drag_started.connect(func(): is_dragging = true)
	seek_bar.drag_ended.connect(func(_v): is_dragging = false)
	seek_bar.value_changed.connect(_on_seek_bar_dragged)
	seek_bar.max_value = 100

func _process(_delta):
	if player.playing and not is_dragging:
		var duration = player.stream.get_length()
		if duration > 0:
			var pos = player.get_playback_position()
			seek_bar.value = (pos / duration) * 100.0
			time_label.text = "%02d:%02d / %02d:%02d" % [pos/60, int(pos)%60, duration/60, int(duration)%60]

func _on_seek_bar_dragged(value: float):
	if player.stream:
		var duration = player.stream.get_length()
		player.seek((value / 100.0) * duration)

func _on_play_button_pressed():
	if player.playing:
		player.stop()
	else:
		player.play()
