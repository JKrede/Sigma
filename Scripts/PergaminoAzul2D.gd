extends Area2D

func _on_PergaminoAzul2D_body_entered(body):
	if body is Player:
		Global.blue = true
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
			"blue" : Global.blue
		}
	}

func load_game(stats):
	position = Vector2(stats.x_pos, stats.y_pos)
	if stats.stats.blue:
		queue_free()
	else:
		Global.blue=stats.stats.blue
