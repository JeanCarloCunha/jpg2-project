extends HSlider

@export var bus_audio_name: String

var bus_audio_id

func _ready():
	bus_audio_id = AudioServer.get_bus_index(bus_audio_name)

func _on_value_changed(value: float) -> void:
	AudioPlayer.set_music_config(null,value)
