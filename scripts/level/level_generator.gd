extends Node3D
class_name LevelGenerator

# ─────────────────────────────────────────────
#  EXPORTS
# ─────────────────────────────────────────────

@export var start_room_scene: PackedScene
@export var room_scenes: Array[PackedScene]
@export var rooms_parent: Node
@export var max_rooms: int = 20
@export var room_gap: float = 0.3

@export_category("Components")
@export var pathfinding: Node

# ─────────────────────────────────────────────
#  CONSTANTS
# ─────────────────────────────────────────────

# All possible mirror scales for room variation (flipping axes instead of rotating)
const ROOM_SCALES := [
	Vector3( 1, 1,  1),  # normal
	Vector3(-1, 1,  1),  # flipped X
	Vector3( 1, 1, -1),  # flipped Z
	Vector3(-1, 1, -1),  # flipped X and Z
]

const MAX_ROTATION_TRIES := 10
const MAX_PLACEMENT_TRIES_MULTIPLIER := 200

# ─────────────────────────────────────────────
#  STATE
# ─────────────────────────────────────────────

var rooms: Array[Room] = []
var connections: Array[Dictionary] = []

var _rng := RandomNumberGenerator.new()
var _room_type_cache: Dictionary = {}  # resource_path -> room_type


# ─────────────────────────────────────────────
#  PUBLIC API
# ─────────────────────────────────────────────

## Builds a full level from the given seed. Same seed = same level on every machine.
func build(seed: int) -> void:
	_rng.seed = seed

	# Sort scenes by path so the order is identical on every machine
	room_scenes.sort_custom(func(a, b): return a.resource_path < b.resource_path)
	_cache_room_types()

	_clear()
	_place_start_room()
	await _fill_level()
	await pathfinding.build_finished(rooms)


# ─────────────────────────────────────────────
#  SETUP HELPERS
# ─────────────────────────────────────────────

func _clear() -> void:
	for room in rooms:
		room.clear()
		room.queue_free()
	rooms.clear()
	connections.clear()


## Cache each scene's room_type so we never instantiate throwaway objects during generation.
func _cache_room_types() -> void:
	_room_type_cache.clear()
	for scene in room_scenes:
		var temp: Room = scene.instantiate()
		_room_type_cache[scene.resource_path] = temp.room_type
		temp.free()


func _place_start_room() -> void:
	var room := _instantiate_room(start_room_scene, Vector3.ZERO)
	rooms.append(room)


# ─────────────────────────────────────────────
#  GENERATION LOOP
# ─────────────────────────────────────────────

## Keeps trying to attach new rooms until we hit max_rooms or run out of doors.
func _fill_level() -> void:
	# Queue holds rooms that still have open doors to attach to
	var open_rooms: Array[Room] = [rooms[0]]
	var tries := 0
	var max_tries := max_rooms * MAX_PLACEMENT_TRIES_MULTIPLIER

	while rooms.size() < max_rooms and tries < max_tries:
		tries += 1

		# Remove rooms with no doors left
		open_rooms = open_rooms.filter(func(r): return not r.doors.is_empty())
		if open_rooms.is_empty():
			break

		# Pick the first room in the queue and one of its open doors
		var current_room: Room = open_rooms[0]
		var door = _pick_random(current_room.doors)

		# Try to attach a new room through that door
		var new_room := await _try_attach_room(current_room, door)

		# Close this door regardless of success — we only try each door once
		current_room.doors.erase(door)

		if new_room != null:
			open_rooms.append(new_room)


# ─────────────────────────────────────────────
#  ROOM ATTACHMENT
# ─────────────────────────────────────────────

## Tries to place a new room that connects to `parent_room` through `parent_door`.
## Returns the new Room on success, or null if placement failed.
func _try_attach_room(parent_room: Room, parent_door: Dictionary) -> Room:
	var attach_dir: Vector3 = parent_door["dir"]
	var scene := _pick_different_scene(parent_room.room_type)

	# Spawn the room roughly in position — we'll align it precisely below
	var rough_pos = parent_room.global_position - parent_door["to_center"] + attach_dir * room_gap
	var room := _instantiate_room(scene, rough_pos)

	# Find a door on the new room that faces back toward the parent
	var matching_door := _find_matching_door(room, -attach_dir)
	if matching_door.is_empty():
		room.queue_free()
		return null

	# Align the new room so its matching door lines up with the parent door
	room.global_position += matching_door["to_center"]

	# Check for overlap with existing rooms
	if not _has_clear_space(room):
		room.queue_free()
		return null

	# Finalize the connection
	room.doors.erase(matching_door)
	rooms.append(room)
	connections.append({ "from": parent_room, "to": room, "door": matching_door })
	parent_room.children.append(room)
	room.parent = parent_room

	return room


## Tries up to MAX_ROTATION_TRIES random scale flips to find a door facing `target_dir`.
func _find_matching_door(room: Room, target_dir: Vector3) -> Dictionary:
	for i in MAX_ROTATION_TRIES:
		room.scale = _pick_random(ROOM_SCALES)
		room.clear()
		room.build()
		var door := room.get_door_by_dir(target_dir)
		if not door.is_empty():
			return door
	return {}


# ─────────────────────────────────────────────
#  OVERLAP CHECK  (deterministic — no physics frame awaiting)
# ─────────────────────────────────────────────

## Returns true if the room can be placed without overlapping any existing room.
func _has_clear_space(room: Room) -> bool:
	var space := room.get_world_3d().direct_space_state
	var coll_shape: CollisionShape3D = room.get_node("coll")

	var query := PhysicsShapeQueryParameters3D.new()
	query.shape = coll_shape.shape
	query.transform = coll_shape.global_transform
	query.exclude = [room]

	var overlaps := space.intersect_shape(query)

	if room.has_node("detector"):
		room.get_node("detector").queue_free()

	if overlaps.is_empty():
		coll_shape.disabled = false  # Enable collision for future checks
		return true

	return false


# ─────────────────────────────────────────────
#  UTILITIES
# ─────────────────────────────────────────────

func _instantiate_room(scene: PackedScene, pos: Vector3) -> Room:
	var room: Room = scene.instantiate()
	rooms_parent.add_child(room)
	room.global_position = pos
	room.scale = _pick_random(ROOM_SCALES)
	room.build()
	return room


## Picks a scene whose room_type differs from `current_type`.
## Falls back to any scene if no different type exists.
func _pick_different_scene(current_type: Variant) -> PackedScene:
	var different := room_scenes.filter(func(s):
		return _room_type_cache.get(s.resource_path) != current_type
	)
	var pool := different if not different.is_empty() else room_scenes
	return _pick_random(pool)


## Picks a uniformly random element from an array using the seeded RNG.
func _pick_random(array: Array) -> Variant:
	return array[_rng.randi_range(0, array.size() - 1)]