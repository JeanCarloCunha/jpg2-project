extends Control

@export var menu_music: AudioStream

func _ready() -> void:
	AudioPlayer.set_music_config(menu_music)

func _on_return_button_down() -> void:
	SceneSwitcher.switch_scene("res://scenes/menu/start_menu.tscn")

func _on_check_button_toggled(toggled_on: bool) -> void:
	var w := get_window()
	if toggled_on:
		# mais compatível em 4.4.1 (funciona em todas as GPUs)
		w.mode = Window.MODE_FULLSCREEN
	else:
		w.mode = Window.MODE_WINDOWED
		# opcional: restaurar tamanho padrão do projeto e centralizar
		var vw := int(ProjectSettings.get_setting("display/window/size/viewport_width"))
		var vh := int(ProjectSettings.get_setting("display/window/size/viewport_height"))
		w.size = Vector2i(vw, vh)
		w.move_to_center()
