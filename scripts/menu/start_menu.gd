extends Control

@export var menu_music: AudioStream

func _ready():
	AudioPlayer.set_music_config(menu_music)

func _on_start_button_down():
	#TODO: tela de carregamento
	#TODO: levar jogador para tela inicial
	#TODO: load informações do jogador
	SceneSwitcher.switch_scene("res://scenes/menu/options_menu.tscn")

func _on_options_button_down():
	#TODO: Levar para tela de opções
	SceneSwitcher.switch_scene("res://scenes/menu/options_menu.tscn")

func _on_quit_button_down():
	get_tree().quit()
