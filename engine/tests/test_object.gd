func test_in():
    assert(1 in [1, 2, 3])
    assert("name" in {"name": "godot"})
    var node: Node = Node.new()
    assert(node in [node])
    assert("name" in node)
    node.free()

func test_get_set():
    var node: Node = Node.new()
    node.set("name", "godot")
    assert(node.get("name") == "godot")
    node.free()

func test_call():
    var node: Node = Node.new()
    node.call("set", "name", "godot")
    assert(node.call("get", "name") == "godot")
    node.free()

func test_has_method():
    var node: Node = Node.new()
    assert(node.has_method("set"))
    assert(node.has_method("get"))
    node.free()

func test_has_signal():
    var node: Node = Node.new()
    assert(node.has_signal("ready"))
    node.ready.connect(func (): node.name = 'ready')
    node.emit_signal("ready")
    assert(node.name == 'ready')
    node.free()
