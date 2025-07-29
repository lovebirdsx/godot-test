# Explosion.gd
extends Node2D

# 预加载子节点，提高效率
@onready var particles: GPUParticles2D = $Particles
@onready var shockwave: Sprite2D = $Shockwave
@onready var flash: PointLight2D = $Flash
@onready var lifetime_timer: Timer = $Lifetime

func _ready() -> void:
	# 启动爆炸效果
	explode()

func explode() -> void:
	# 1. 触发粒子发射
	particles.emitting = true
	
	# 2. 播放冲击波动画
	# play_shockwave_animation()
	
	# 3. 播放闪光动画
	# play_flash_animation()
	
	# 5. 设置计时器，在效果结束后销毁此场景
	lifetime_timer.wait_time = particles.lifetime + 0.1 # 保证所有粒子消失后再销毁
	lifetime_timer.one_shot = true
	lifetime_timer.start()
	# 连接计时器的 timeout 信号到 queue_free 方法
	lifetime_timer.timeout.connect(queue_free)


func play_shockwave_animation() -> void:
	# 使用 Tween 来实现冲击波的放大和淡出动画
	var tween = create_tween()
	
	# 初始化冲击波状态
	shockwave.scale = Vector2.ZERO
	shockwave.modulate = Color(1, 1, 1, 1) # 完全不透明
	
	# 并行动画：同时改变 scale 和 modulate
	tween.parallel().tween_property(shockwave, "scale", Vector2(1, 1) * 1.5, 0.3)\
		.set_trans(Tween.TRANS_QUART)\
		.set_ease(Tween.EASE_OUT)
		
	tween.parallel().tween_property(shockwave, "modulate:a", 0.0, 0.3)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)


func play_flash_animation() -> void:
	var tween = create_tween()
	
	flash.enabled = true
	flash.energy = 5.0
	
	tween.tween_property(flash, "energy", 0.0, 0.1)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	tween.tween_callback(func(): flash.enabled = false)
