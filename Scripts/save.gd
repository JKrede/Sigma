extends Node

var save_filename = "user://save_data.save"

func _process(delta):
	if Input.is_action_just_pressed("guardar"):
		print("Guardando juego...")
		save_juego()
	if Input.is_action_just_pressed("cargar"):
		print("Cargando juego...")
		load_juego()

func save_juego():
	print("Iniciando guardado...")
	var save_file = File.new()
	if save_file.open(save_filename, File.WRITE) != OK:
		print("No se pudo abrir el archivo para guardar")
		return
	var saved_nodes = get_tree().get_nodes_in_group("save")
	for node in saved_nodes:
		if node.filename.empty():
			break
		var node_details = node.save_game()
		save_file.store_line(to_json(node_details))
	save_file.close()
	print("Juego guardado")

func load_juego():
	print("Iniciando carga...")
	var save_file = File.new()
	if not save_file.file_exists(save_filename):
		print("Archivo de guardado no encontrado")
		return
	if save_file.open(save_filename, File.READ) != OK:
		print("No se pudo abrir el archivo para cargar")
		return
	# Crear una lista para almacenar los nuevos nodos cargados
	var new_objects = []
	while save_file.get_position() < save_file.get_len():
		var node_data = parse_json(save_file.get_line())
		var new_obj = load(node_data.filename).instance()
		get_node(node_data.parent).call_deferred("add_child", new_obj)
		new_obj.load_game(node_data)
		new_objects.append(new_obj)  # Agregar el nuevo nodo a la lista
	save_file.close()
	# Eliminar los nodos actuales después de cargar los nuevos nodos
	var saved_nodes = get_tree().get_nodes_in_group("save")
	for node in saved_nodes:
		node.queue_free()
	# Opcional: almacenar los nuevos nodos en el grupo "save" si es necesario
	for obj in new_objects:
		obj.add_to_group("save")
	print("Juego cargado")
