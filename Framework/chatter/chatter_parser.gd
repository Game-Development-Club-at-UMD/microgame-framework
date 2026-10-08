class_name ChatterParser
extends RefCounted


static func read_lines(path: String) -> Array[String]:
	var lines: Array[String] = []
	
	if not FileAccess.file_exists(path):
		push_error("FileUtils: file does not exist at path: %s" % path)
		return lines
	
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("FileUtils: failed to open %s (error code %d)" % [path, FileAccess.get_open_error()])
		return lines
	
	while not file.eof_reached():
		var line: String = file.get_line()
		if line.strip_edges().is_empty():
			continue
		lines.append(line)
	
	file.close()
	return lines
