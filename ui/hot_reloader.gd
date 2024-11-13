extends Node

class_name HotReload

var _file_mod_times: Dictionary = {}

const CHECK_INTERVAL = 1.0
const PATH = "res://"

func _ready():
	_initialize_file_mod_times()
	
	var timer = Timer.new()
	timer.wait_time = CHECK_INTERVAL
	timer.autostart = true
	timer.one_shot = false
	timer.connect("timeout", self._on_timeout)
	add_child(timer)


func _initialize_file_mod_times():
	var dir: DirAccess = DirAccess.open(PATH);
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".gd"):
				var file_path = PATH + file_name
				var mod_time = FileAccess.get_modified_time(file_path)
				_file_mod_times[file_path] = mod_time
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Failed to open directory: ", PATH)


func _on_timeout():
	var changes_detected = false
	var dir: DirAccess = DirAccess.open(PATH);
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var current_files = {}
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".gd"):
				var file_path = PATH + file_name
				var mod_time = FileAccess.get_modified_time(file_path)
				current_files[file_path] = mod_time
				if not _file_mod_times.has(file_path):
					# New file detected
					print("New .gd file detected: ", file_path)
					changes_detected = true
				elif _file_mod_times[file_path] < mod_time:
					# Existing file modified
					print(".gd file modified: ", file_path)
					changes_detected = true
			file_name = dir.get_next()
		dir.list_dir_end()
		
		# Check for deleted files
		for file_path in _file_mod_times.keys():
			if not current_files.has(file_path):
				print(".gd file deleted: ", file_path)
				changes_detected = true
		
		# Update the file modification times
		_file_mod_times = current_files
		if changes_detected:
			get_tree().reload_current_scene()
			print("Reloading scene...")
	else:
		print("Failed to open directory: ", PATH)
