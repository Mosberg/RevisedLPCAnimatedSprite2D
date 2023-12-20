@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("LPCAnimatedSprite2DRevised", "Node2D", preload("LPCAnimatedSprite2DRevised.gd"), null)


func _exit_tree():
	remove_custom_type("LPCAnimatedSprite2DRevised")
