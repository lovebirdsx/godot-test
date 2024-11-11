func test_get_property_list():
    var node: Node = Node.new()
    var properties = node.get_property_list()
    assert(properties.size() > 0)
    node.free()

func test_set_script():
    var node: Node = Node.new()
    assert(ScriptForTest.init_count == 0)

    var script = load("res://script_for_test.gd")
    node.set_script(script)
    assert(node.get_script() == script)
    node.set_script(null)
    node.free()

    assert(ScriptForTest.init_count == 1)
