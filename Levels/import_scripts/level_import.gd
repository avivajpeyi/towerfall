@tool

extends Node

func post_import(level: LDTKLevel) -> LDTKLevel:
	for child in level.get_children():
		if child is TileMapLayer:
			child = child as TileMapLayer
			child.collision_visibility_mode =TileMapLayer.DEBUG_VISIBILITY_MODE_FORCE_SHOW
		print("Success in imporing level!")
	return level
