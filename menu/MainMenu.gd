extends Node2D

export (PackedScene) var fireball_scene
var fire_ball: Node

func _ready():
	var _random_var = get_tree().connect("network_peer_connected",self,"_connected")

func _on_Host_create_pressed():
	var server = NetworkedMultiplayerENet.new()
	server.create_server(8080, 2)
	get_tree().set_network_peer(server)
	

func _on_Join_pressed():
	var client = NetworkedMultiplayerENet.new()
	client.create_client("127.0.0.1", 8080)
	get_tree().set_network_peer(client)

func _connected(client_id):
	Singleton.user_id = client_id
	var game = preload("res://levels/Game.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()
