extends Control

var url = "http://127.0.0.1:11434/api/generate"
var header = ["Content-Type: application/json"]

var chatData = {
	"model": "qwen3.5:9b",
	"prompt": "",
	"stream": false,
	"options":{
		"temperature": 0.7,
		"max_tokens": 1000
	}
}

@onready var botTxt = $PanelContainer/VBoxContainer/ScrollContainer/RichTextLabel
@onready var userTxt =  $PanelContainer/VBoxContainer/LineEdit

var httpClient = HTTPClient.new()
var is_connect = false
var is_stream = true

func _ready() -> void:
	chatData.stream = is_stream
	
	if is_stream:
		var err = httpClient.connect_to_host("http://127.0.0.1", 11434)
		if err == OK:
			is_connect = true
		pass
	else:
		$HTTPRequest.request_completed.connect(_request_completed)
	pass
	
func _request_completed(result, response, headers, body):
	var str = body.get_string_from_utf8()
	var json = JSON.parse_string(str)
	if json != null:
		botTxt.text += json.response
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("send"):
		chatData.prompt = userTxt.text
		userTxt.text = ""
		
		if is_stream:
			var httpclient_status = httpClient.get_status()
			if httpclient_status == HTTPClient.STATUS_CONNECTING or httpclient_status == HTTPClient.STATUS_RESOLVING:
				return
				
			if httpclient_status == HTTPClient.STATUS_CONNECTED:
				httpClient.request(HTTPClient.METHOD_POST, "/api/generate", header, JSON.stringify(chatData))
			pass
			
		else:
			$HTTPRequest.request(url, header,HTTPClient.METHOD_POST, JSON.stringify(chatData))
			
	pass

func _process(delta: float) -> void:
	if !is_connect:
		return
		
	httpClient.poll()
	
	var httpclient_status = httpClient.get_status()
	var httpclient_has_response = httpClient.has_response()	
	if httpclient_has_response and httpclient_status == httpClient.STATUS_BODY:
		var chunk = httpClient.read_response_body_chunk()
		if chunk.size() > 0:
			var str = chunk.get_string_from_utf8()
			var json = JSON.parse_string(str)
			if json != null:
				botTxt.text += json.response
	pass
