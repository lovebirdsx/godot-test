class_name Config

var is_server: bool = false
var port: int = 12345
var max_clients: int = 4

static func instance() -> Config:
    return Config.new()


func _init() -> void:
    for arg in OS.get_cmdline_args():
        if arg == "--server":
            is_server = true
        elif arg.begins_with("--port="):
            port = int(arg.split("=")[1])
        elif arg.begins_with("--max-clients="):
            max_clients = int(arg.split("=")[1])
    
    print("is_server: ", is_server)
    print("port: ", port)
    print("max_clients: ", max_clients)
