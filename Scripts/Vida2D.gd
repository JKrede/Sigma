extends Area2D

var collected = false

func _on_Vida2D_body_entered(body):
	if body is Player:
		Global.contador_vida +=1
		collected = true
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
			"collected" : collected
		}
	}

func load_game(stats):
	position = Vector2(stats.x_pos, stats.y_pos)
	if stats.stats.collected:
		queue_free()
	else:
		collected=stats.stats.collected
