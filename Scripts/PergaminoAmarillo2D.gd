extends Area2D

func save_game():
	return {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"x_pos" : position.x,
		"y_pos" : position.y,
		"stats" :{
			"yellow" : Global.yellow
		}
	}

func load_game(stats):
	position = Vector2(stats.x_pos, stats.y_pos)
	if stats.stats.yellow:
		queue_free()
	else:
		Global.yellow=stats.stats.yellow


func _on_PergaminoAmarillo2D_body_entered(body):
	if body is Player:
		Global.yellow=true
		queue_free()
	else:
		# Si el cuerpo que entra no es el del jugador, no hacemos nada
		pass
