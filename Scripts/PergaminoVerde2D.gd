extends Area2D

func _on_PergaminoVerde2D_body_entered(body):
	if body is Player:
		Global.green = true
		queue_free()
	else:
		# Si el cuerpo que entra no es el del jugador, no hacemos nada
		pass

func save_game():
	return {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"x_pos" : position.x,
		"y_pos" : position.y,
		"stats" :{
		"green" : Global.green
		}
	}

func load_game(stats):
	position = Vector2(stats.x_pos, stats.y_pos)
	if stats.stats.green:
		queue_free()
	else:
		Global.green=stats.stats.green
