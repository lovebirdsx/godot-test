class_name TestClassDB

func test_simple():
    assert(ClassDB.can_instantiate("Node"))
    assert(ClassDB.can_instantiate("TestClassDB"))

func test_enum():
    assert(ClassDB.class_get_enum_list("Node").size() > 0)
    assert(ClassDB.class_get_enum_constants("Node", "ProcessMode").size() > 0)

func test_is_parent_class():
    assert(ClassDB.is_parent_class("Node", "Object"))
    assert(ClassDB.is_parent_class("Node", "Node"))
    assert(!ClassDB.is_parent_class("Node", "RefCounted"))
    assert(!ClassDB.is_parent_class("Node", "TestClassDB"))
    assert(ClassDB.is_parent_class("RefCounted", "Object"))
    
    assert(ClassDB.get_parent_class("Node") == "Object")
    assert(ClassDB.get_parent_class("Script") == "Resource")
    assert((ClassDB.get_parent_class("Resource") == "RefCounted"))
