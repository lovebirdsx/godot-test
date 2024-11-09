extends SceneTree

func _init():
    # 扫描./tests目录下的所有test_*.gd文件
    # 并执行其中的test_*函数
    var dir = DirAccess.open("res://tests")
    dir.list_dir_begin()

    while true:
        var file = dir.get_next()
        if file == "":
            break

        if file.ends_with(".gd") and file.begins_with("test_"):
            var path = "res://tests/" + file
            var script = load(path)
            var instance = script.new()            
            var methods = instance.get_method_list()
            print(file)
            for method in methods:
                if method.name.begins_with("test_"):
                    print("  " + method.name)
                    instance.call(method.name)

    quit()
