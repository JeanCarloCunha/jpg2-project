extends Control

@export var menu_music: AudioStream
@export var chk_fullscreen_path: NodePath      # arraste aqui o CheckButton "Tela cheia"
@export var return_button_path: NodePath       # arraste aqui o botão "Return"

@onready var chk_fullscreen: CheckButton = get_node_or_null(chk_fullscreen_path)
@onready var btn_return: Button = get_node_or_null(return_button_path)


# CONTROLES DE VOLUME (arraste no Inspetor)
@export var volume_slider_path: NodePath      # HSlider (0..1)
@export var mute_toggle_path: NodePath        # CheckButton (mudo)

@onready var volume_slider: HSlider = get_node_or_null(volume_slider_path)
@onready var mute_toggle: CheckButton = get_node_or_null(mute_toggle_path)

const BGM_BUS := "Master"   # troque para "BGM" se você criou esse bus

func _ready() -> void:
	# música (se usar)
	if menu_music:
		AudioPlayer.set_music_config(menu_music)

	# sincroniza visual do toggle ao entrar
	if chk_fullscreen:
		chk_fullscreen.set_pressed_no_signal(UserSettings.fullscreen)
		if not chk_fullscreen.toggled.is_connected(_on_check_button_toggled):
			chk_fullscreen.toggled.connect(_on_check_button_toggled)
	else:
		push_error("Defina 'chk_fullscreen_path' no Inspetor apontando para o seu CheckButton.")

	# conecta Return
	if btn_return:
		if not btn_return.pressed.is_connected(_on_return_pressed):
			btn_return.pressed.connect(_on_return_pressed)
	else:
		push_error("Defina 'return_button_path' no Inspetor apontando para o seu botão Return.")



# quando a tela voltar a ficar visível, reafirma o estado do botão
func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and is_visible_in_tree() and chk_fullscreen:
		chk_fullscreen.set_pressed_no_signal(UserSettings.fullscreen)

func _on_check_button_toggled(toggled_on: bool) -> void:
	# salva globalmente e aplica o modo da janela
	UserSettings.fullscreen = toggled_on
	var w := get_window()
	if toggled_on:
		w.mode = Window.MODE_FULLSCREEN
	else:
		w.mode = Window.MODE_WINDOWED
		var vw := int(ProjectSettings.get_setting("display/window/size/viewport_width"))
		var vh := int(ProjectSettings.get_setting("display/window/size/viewport_height"))
		w.size = Vector2i(vw, vh)
		w.move_to_center()

func _on_return_pressed() -> void:
	# use SceneSwitcher se você já usa; caso não, troque pela linha comentada abaixo
	SceneSwitcher.switch_scene("res://scenes/menu/start_menu.tscn")
	# get_tree().change_scene_to_file("res://scenes/menu/start_menu.tscn")
