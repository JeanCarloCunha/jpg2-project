extends AudioStreamPlayer

func set_music_config(music: AudioStream = null, volume: float = 0.5):
	if music == null:
		music = get_current_music()
	
	if stream != music:
		_set_current_music_and_play(music)
	
	if volume_db != linear_to_db(volume):
		_set_volume(linear_to_db(volume))
	return

func _set_volume(volume: float):
	volume_db = volume

func _set_current_music_and_play(music: AudioStream):
	stream = music
	play()
	return

func get_current_music():
	return stream
