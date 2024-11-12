extends Node

var game: Node2D
var ephemeral: Node2D
var player: Node2D

var points: int = 0

enum WeaponState {GROUNDED, HELD, INVENTORY}

var random = RandomNumberGenerator.new()

const LAYER_WORLD = 1
const LAYER_PLAYER = 13
const LAYER_ENEMIES = 9
const LAYER_INTERACTION = 14
const LAYER_TOUCH = 15
const MASK_WORLD = 1 << (LAYER_WORLD - 1)
const MASK_PLAYER = 1 << (LAYER_PLAYER - 1)
const MASK_ENEMIES = 1 << (LAYER_ENEMIES - 1)
