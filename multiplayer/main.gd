extends Node


@export var lable: Label


func _ready() -> void:
	multiplayer.peer_connected.connect(func (id: int) -> void:
		print("Peer connected: ", id)
		lable.text = "Peer connected: " + str(id)
	)

	multiplayer.peer_disconnected.connect(func (id: int) -> void:
		print("Peer disconnected: ", id)
		lable.text = "Peer disconnected: " + str(id)
	)

	multiplayer.connected_to_server.connect(func () -> void:
		print("Connected to server")
		lable.text = "Connected to server"
	)

	multiplayer.server_disconnected.connect(func () -> void:
		print("Disconnected from server")
		lable.text = "Disconnected from server"
	)

	multiplayer.connection_failed.connect(func () -> void:
		print("Connection failed")
		lable.text = "Connection failed"
	)

	var config: Config = Config.instance()
	if config.is_server:
		var peer = ENetMultiplayerPeer.new()
		var error = peer.create_server(config.port, config.max_clients)
		if error != OK:
			print("Error creating server: ", error)
			lable.text = "Error creating server: " + str(error)
			return

		multiplayer.multiplayer_peer = peer
		print("Server started on port: ", config.port)
		lable.text = "Server started on port: " + str(config.port)
	else:
		var peer = ENetMultiplayerPeer.new()
		var error = peer.create_client("localhost", config.port)
		if error != OK:
			print("Error connecting to server: ", error)
			lable.text = "Error connecting to server: " + str(error)
			return

		multiplayer.multiplayer_peer = peer
		print("Client start connected to server on port: ", config.port)
		lable.text = "Client start connected to server on port: " + str(config.port)


@rpc("any_peer", "call_local")
func set_label_text(text: String) -> void:
	lable.text = text


func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()


func _on_button_1_pressed() -> void:
	rpc("set_label_text", "Hello")
	print("Button 1 pressed")


func _on_button_2_pressed() -> void:
	rpc("set_label_text", "World")
	print("Button 2 pressed")
