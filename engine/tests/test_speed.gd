const COUNT = 1000000

func _sum1() -> int:
    var start_time = Time.get_ticks_msec()
    var _sum: int = 0
    for i in range(1, COUNT+1):
        _sum += i
    var end_time = Time.get_ticks_msec()
    var elapsed = end_time - start_time
    return elapsed


func _sum2() -> int:
    var start_time = Time.get_ticks_msec()
    var _sum = 0
    for i in range(1, COUNT+1):
        _sum += i
    var end_time = Time.get_ticks_msec()
    var elapsed = end_time - start_time
    return elapsed


func test_speed():
    # sum1和sum2的差别在于sum1进行了类型标注
    # 结果是sum1比sum2快大概27%
    var time1: int = _sum1()
    var time2: int = _sum2()
    print("    sum1: %d ms" % time1)
    print("    sum2: %d ms" % time2)

    
