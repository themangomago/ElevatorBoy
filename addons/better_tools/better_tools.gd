@tool
extends EditorPlugin


func _enter_tree():
	add_tool_menu_item("Open in VS Code", Callable(self, "_open_code"))
	add_tool_menu_item("Open Project Folder", Callable(self, "_open_project"))


func _exit_tree():
	remove_tool_menu_item("Open in VS Code")
	remove_tool_menu_item("Open Project Folder")

func _open_code():
	var output = []
	if OS.get_name() == "Windows":
		var arg = ProjectSettings.globalize_path("res://addons/better_tools/") + "open_code.bat"
		OS.execute(arg, [], output, false, false)
	else:
		printerr("Better Tools: OS is currently not supported.")

func _open_project():
	var path = ProjectSettings.globalize_path("res://")
	OS.shell_open(path)
