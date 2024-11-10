
var notify_count = 0
func _notification(what: int) -> void:
    if what == NOTIFICATION_EXTENSION_RELOADED:
        notify_count += 1
    

func test_notify():
    notification(NOTIFICATION_EXTENSION_RELOADED)
    assert(notify_count == 1)
