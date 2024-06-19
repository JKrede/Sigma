extends Camera2D

var nombre_instancia = get_name()

func _process(delta):
	if OS.is_window_maximized() or OS.is_window_fullscreen():
		if get_name() != "Camera2Dfullscrean":
			visible = false
		else:
			visible = true
	else:
		if get_name() != "Camera2Dfullscrean":
			visible = true
		else:
			visible = false
	score()

func score():
	if Global.contador_oro<10:
		$CoinOro2.text="x0"+str(Global.contador_oro)
	else:
		$CoinOro2.text="x"+str(Global.contador_oro)
	if Global.contador_plata<10:
		$CoinPlata2.text="x0"+str(Global.contador_plata)
	else:
		$CoinPlata2.text="x"+str(Global.contador_plata)
	$Vida2.text="x"+str(Global.contador_vida)
	if Global.contador_kills<10:
		$Kills2.text="x0"+str(Global.contador_kills)
	else:
		$Kills2.text="x"+str(Global.contador_kills)
	update_life_bar()
	$PergaminoRojo.visible = Global.red
	$PergaminoAzul.visible = Global.blue
	$PergaminoAmarillo.visible = Global.yellow
	$PergaminoVerde.visible = Global.green

func update_life_bar():
	var life_percentage = Global.actualLife / Global.maxLife
	var bar = $barra1/barra2  
	var original_width = bar.texture.get_size().x  
	bar.scale.x = life_percentage
	bar.position.x = -(original_width - (original_width * bar.scale.x)) * 0.5
