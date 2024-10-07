@tool

const Player = preload("res://Entities/Player/Player.tscn")
const Goal = preload("res://Entities/Goal/Goal.tscn")
const DoorKey = preload("res://Entities/DoorKey/door_key.tscn")
const Door = preload("res://Entities/Door/door.tscn")
const Spikes = preload("res://Entities/Hazards/FloorSpikes.tscn")
const SpikesLeft = preload("res://Entities/Hazards/FloorSpikesLeft.tscn")
const SpikesRight = preload("res://Entities/Hazards/FloorSpikesRight.tscn")
const BreakableBlock = preload("res://Entities/BreakableBlock/breakable_block.tscn")
const SpikeShooter = preload("res://Entities/fall_spike/SpikeShooter.tscn")
const Spring = preload("res://Entities/Spring/Spring.tscn")
const BallShooter = preload("res://Entities/ball_shooter/Shooter.tscn")
const Title = preload("res://Entities/title/Title.tscn")

const LDTKUtil = preload("res://addons/ldtk-importer/src/util/util.gd")


func post_import(entity_layer: LDTKEntityLayer) -> LDTKEntityLayer:
	var definition: Dictionary = entity_layer.definition
	var entities: Array = entity_layer.entities

	print("EntityLayer: ", entity_layer.name, " | Count: ", entities.size())
	for entity in entities:
		if entity.identifier == "Player":
			_add_scn_at_entity(Player, entity, entity_layer)
			print("Just added player")
		elif entity.identifier == "Goal":
			_add_scn_at_entity(Goal, entity, entity_layer)
		elif entity.identifier == "Key":
			_add_scn_at_entity(DoorKey, entity, entity_layer)
		elif entity.identifier == "Door":
			_add_scn_at_entity(Door, entity, entity_layer)
		elif entity.identifier == "Spikes":
			_add_scn_at_entity(Spikes, entity, entity_layer)
		elif entity.identifier == "SpikesLeft":
			_add_scn_at_entity(SpikesLeft, entity, entity_layer)
		elif entity.identifier == "SpikesRight":
			_add_scn_at_entity(SpikesRight, entity, entity_layer)
		elif entity.identifier == "BreakableBlock":
			_add_scn_at_entity(BreakableBlock, entity, entity_layer)
		elif entity.identifier == "FallingSpike":
			_add_scn_at_entity(SpikeShooter, entity, entity_layer)
		elif entity.identifier == "Spring":
			_add_scn_at_entity(Spring, entity, entity_layer)
		elif entity.identifier == "BallShoter":
			_add_scn_at_entity(BallShooter, entity, entity_layer)
		elif entity.identifier == "Text":
			_add_scn_at_entity(Title, entity, entity_layer)
		
		
		else:
			print("Entity " + entity.identifier + " not processed")
			
			
	print("Successfully loaded entities!")

	return entity_layer


func _add_scn_at_entity(scn, entity, entity_layer):
	var node = scn.instantiate()
	node.position = entity.position
	node.set_meta("entity_data", entity)
	entity_layer.add_child(node)
	print("Spawned ", entity.identifier)
	LDTKUtil.update_instance_reference(entity.iid, node)
	
