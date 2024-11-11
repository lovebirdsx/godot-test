func test_type():
    var intVar = 1
    assert(intVar is int)
    assert(typeof(intVar) == TYPE_INT)

    var floatVar = 1.0
    assert(floatVar is float)
    assert(typeof(floatVar) == TYPE_FLOAT)

    var stringVar = "hello"
    assert(stringVar is String)
    assert(typeof(stringVar) == TYPE_STRING)

    var boolVar = true
    assert(boolVar is bool)
    assert(typeof(boolVar) == TYPE_BOOL)

    var arrayVar = [1, 2, 3]
    assert(arrayVar is Array)
    assert(typeof(arrayVar) == TYPE_ARRAY)

    var dictVar = {"a": 1, "b": 2}
    assert(dictVar is Dictionary)
    assert(typeof(dictVar) == TYPE_DICTIONARY)

    var objectVar = Node.new()
    assert(objectVar is Object)
    assert(typeof(objectVar) == TYPE_OBJECT)
    assert(objectVar.get_class() == "Node")
    objectVar.free()

func test_detect_type():
    assert(type_string(typeof(123)) == 'int')
    assert(type_string(typeof(123.0)) == 'float')
    assert(type_string(typeof("123")) == 'String')
    assert(type_string(typeof(true)) == 'bool')

func test_str_to_var():
    var array = [1, 2, 3]
    assert(array.size() == 3)
    var str1 = var_to_str(array)
    assert(str1 == "[1, 2, 3]")
    var array2 = str_to_var(str1)
    assert(array2.size() == array.size())

func test_var_to_bytes():
    var array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    var bytes = var_to_bytes(array)
    var array2 = bytes_to_var(bytes)
    assert(array2.size() == array.size())
