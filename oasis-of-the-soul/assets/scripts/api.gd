extends Control

# ============ 在这里填你自己的魔搭API Key ============
const MS_API_KEY = "你的modelscope密钥"
const MS_API_URL = "https://api-inference.modelscope.cn/v1/chat/completions"
const MODEL = "qwen-turbo"
# ======================================================

@onready var chat_log: RichTextLabel = $ChatLog
@onready var input_box: LineEdit = $InputBox
@onready var btn_send: Button = $BtnSend
@onready var http: HTTPRequest = $HTTPRequest

# 对话上下文
var msg_list: Array[Dictionary] = []

func _ready():
	# 初始化树洞人设
	msg_list.append({
		"role": "system",
		"content": "你是一个温柔的情绪树洞，耐心倾听用户的烦恼、情绪、心事。语气柔软治愈，共情安慰，简短温柔回复，不要太冗长，像朋友一样陪伴。"
	})

	# 绑定信号
	btn_send.pressed.connect(_send_msg)
	input_box.submit.connect(_send_msg)
	http.request_completed.connect(_on_response)

# 发送消息
func _send_msg():
	var text = input_box.text.strip_edges()
	if text.empty():
		return

	# 显示自己的话
	chat_log.append_text("你：%s\n" % text)
	input_box.text = ""

	# 加入上下文
	msg_list.append({"role":"user", "content":text})

	# 构造请求
	var body = {
		"model": MODEL,
		"messages": msg_list,
		"temperature": 0.8
	}

	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + MS_API_KEY
	]

	# Godot4 标准4参数，绝不报错
	var err = http.request(
		MS_API_URL,
		headers,
		HTTPClient.METHOD_POST,
		JSON.stringify(body)
	)

	if err != OK:
		chat_log.append_text("系统：请求失败\n")

# 接收AI回复
func _on_response(res, code, head, body_buf):
	if res != OK or code != 200:
		chat_log.append_text("系统：网络或API错误\n")
		return

	var res_json = JSON.parse_string(body_buf.get_string_from_utf8())
	var ai_reply = res_json.choices[0].message.content.strip_edges()

	# 保存上下文
	msg_list.append({"role":"assistant", "content":ai_reply})

	# 显示AI树洞回复
	chat_log.append_text("树洞：%s\n\n" % ai_reply)
	
