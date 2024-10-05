@tool

const Player = preload("res://Entities/Player/Player.tscn")
const LDTKUtil = preload("res://addons/ldtk-importer/src/util/util.gd")


func post_import(entity_layer: LDTKEntityLayer) -> LDTKEntityLayer:
	var definition: Dictionary = entity_layer.definition
	var entities: Array = entity_layer.entities

	print("EntityLayer: ", entity_layer.name, " | Count: ", entities.size())

	for entity in entities:
		# Perform operations here
		
		print(entity.identifier)
		print(entity)
		if entity.identifier == "Player":
			var player: Player = Player.instantiate()
			player.position = entity.position
			player.name = "Player"
			entity_layer.add_child(player)
			LDTKUtil.update_instance_reference(entity.iid, player)
			print("Spawned Player")
		else:
			print("Entity " + entity.identifier + " not processed")
			
			
	print("Successfully loaded entities!")

	return entity_layer
