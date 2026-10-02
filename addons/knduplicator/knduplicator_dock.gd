@tool
extends Control

@onready var text_edit: TextEdit = $HBoxContainer/VBoxContainer/TextEdit
@onready var select_button: Button = $HBoxContainer/VBoxContainer/SelectButton
@onready var create_button: Button = $HBoxContainer/VBoxContainer/CreateButton
@onready var error_label: Label = $HBoxContainer/VBoxContainer/ErrorLabel
@onready var transformations_label: Label = $HBoxContainer/VBoxContainer2/TransformationsLabel

var selected_path: String = ""

func _ready() -> void:
	select_button.icon = get_theme_icon("FileDialog", "EditorIcons")
	create_button.icon = get_theme_icon("Add", "EditorIcons")


func _on_select_button_pressed() -> void:
	var dialog := EditorFileDialog.new()
	dialog.file_mode = EditorFileDialog.FileMode.FILE_MODE_OPEN_FILE
	dialog.access = EditorFileDialog.Access.ACCESS_RESOURCES
	dialog.add_filter("*.tscn, *.scn", "Scenes")
	dialog.title = "Select a scene"
	add_child(dialog)
	dialog.popup_file_dialog()
	await dialog.visibility_changed
	dialog.queue_free()
	if dialog.current_file != "":
		selected_path = dialog.current_path
	update(false)


func check():
	update(false)

func create():
	update(true)


func show_error(error: String):
	create_button.disabled = true
	error_label.text = error
	error_label.show()
	print("Error: ", error)
	return false


func update(save: bool):
	create_button.disabled = false
	error_label.hide()
	transformations_label.text = ""
	var labels = []
	var error

	var input = text_edit.text.strip_edges().to_lower()
	# Ensure name is entered
	if input == "":
		return show_error("Please enter a new name")
	if not selected_path:
		return show_error("Please select an existing scene")

	var new_filename_base = input.validate_filename().to_snake_case()
	var new_node_name = input.validate_node_name().to_pascal_case()
	var selected_dir = selected_path.get_base_dir()
	var new_scene_path = "%s/%s.tscn" % [selected_dir, new_filename_base]
	if FileAccess.file_exists(new_scene_path):
		return show_error("File already exists %s" % [new_scene_path])
	labels.append("Copy: %s ➝ %s" % [selected_path.get_file(), new_scene_path.get_file()])

	var cls = load(selected_path)
	var node = cls.instantiate()
	var node_name = node.name

	var new_script_path
	var script = node.get_script()
	var script_path
	if script:
		script_path = script.resource_path
		var script_dir = script_path.get_base_dir()
		new_script_path = "%s/%s.gd" % [script_dir, new_filename_base]
		if FileAccess.file_exists(new_script_path):
			return show_error("File already exists %s" % [new_script_path])
		labels.append("Copy: %s ➝ %s" % [script_path.get_file(), new_scene_path.get_file()])

	if not save:
		labels.append("Node: %s ➝ %s" % [node_name, new_node_name])
		transformations_label.text = "\n".join(labels)
		create_button.disabled = false
		error_label.hide()

	if save:
		if script:
			# Save script specific properties, so they can be restored after changing the script.
			var properties = []
			for property in script.get_script_property_list():
				if property["name"] in node:
					properties.push_back([property["name"], node.get(property["name"])])
			# Copy script
			error = DirAccess.copy_absolute(script_path, new_script_path)
			if error != OK:
				return show_error("Could save: %s" % new_script_path)
			var new_script = load(new_script_path)
			if not new_script:
				return show_error("Could not load script: %s" % new_script_path)
			node.set_script(new_script) # Discards exported variables from previous script
			# Restore saved properties
			for property_pair in properties:
				node.set(property_pair[0], property_pair[1])
		node.name = new_node_name
		# Save scene
		var new_scene = PackedScene.new()
		error = new_scene.pack(node)
		if error != OK:
			return show_error("Packing scene failed: " + error)
		error = ResourceSaver.save(new_scene, new_scene_path)
		if error != OK:
			return show_error("Saving scene failed: " + error)

		selected_path = ""
		transformations_label.text = ""
		text_edit.text = ""
		create_button.disabled = true
	return
