extends Area2D

func _on_PergaminoRojo2D_body_entered(body):
	if body is Player:
		Global.red = true
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
			"red" : Global.red
		}
	}

func load_game(stats):
	position = Vector2(stats.x_pos, stats.y_pos)
	if stats.stats.red:
		queue_free()
	else:
		Global.red=stats.stats.red
