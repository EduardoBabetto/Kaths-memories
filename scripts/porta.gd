extends StaticBody2D

@onready var sprite = $Sprite2D
@onready var abrindo = $Abrindo
@onready var fechando = $Fechando

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		fechando.stop()
		abrindo.play()
		$Sprite2D.frame = 1

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		abrindo.stop()
		sprite.frame = 0 # fechada
		fechando.play()
