extends Node

static func load_beatmap(path:String) -> Dictionary:

	if !FileAccess.file_exists(path):
		push_error("Beatmap não encontrado: " + path)
		return {}

	var file = FileAccess.open(path, FileAccess.READ)

	var text = file.get_as_text()

	file.close()

	var json = JSON.new()

	var error = json.parse(text)

	if error != OK:
		push_error("Erro lendo beatmap.")
		return {}

	return json.data
