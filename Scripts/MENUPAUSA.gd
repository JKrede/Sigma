extends Control
onready var menuPausa = $ColorRect/MenuPausa
onready var opciones = $ColorRect/Opciones
onready var video = $ColorRect/Video
onready var audio = $ColorRect/Audio

func _ready():
	visible = false

func _input(event):
	if event .is_action_pressed("pause"):
		visible = not get_tree().paused
		get_tree().paused = not get_tree().paused

func _on_Continuar_pressed():
	visible = not get_tree().paused
	get_tree().paused = not get_tree().paused

func _on_Opciones_pressed():
	show_and_hide(opciones, menuPausa)

func show_and_hide(first, second):
	first.show()
	second.hide()

func _on_Men_Principal_pressed():
	#get_tree().change_scene("res://ruta_de_tu_menu_principal.tscn")
	pass # Replace with function body.

func _on_Video_pressed():
	show_and_hide(video, opciones)

func _on_Audio_pressed():
	show_and_hide(audio, opciones)

func _on_VolverDeOpciones_pressed():
	show_and_hide(menuPausa, opciones)

func _on_FullScreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed

func _on_Borderless_toggled(button_pressed):
	OS.window_borderless = button_pressed

func _on_VSync_toggled(button_pressed):
	OS.vsync_enabled = button_pressed

func _on_VolverDeVideo_pressed():
	show_and_hide(opciones, video)

func _on_Master_value_changed(value):
	volume(0, value)
func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, value)

func _on_Music_value_changed(value):
	volume(1, value)

func _on_Sound_FX_value_changed(value):
	volume(2, value)

func _on_VolverDeAudio_pressed():
	show_and_hide(opciones, audio)

func _on_Guardar_partida_pressed():
	$"/root/Save".save_juego()

func _on_Cargar_partida_pressed():
	$"/root/Save".load_juego()
