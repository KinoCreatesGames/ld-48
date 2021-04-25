package game.char;

// Note we'll be using tiles so don't go over the tile limit
enum MoveDirection {
	UP;
	DOWN;
	LEFT;
	RIGHT;
}

class Actor extends FlxSprite {
	public var name:String;
	public var data:ActorData;
	public var atk:Int;
	public var def:Int;
	public var spd:Int;

	public var moveDirection:MoveDirection;
	public var moveToNextTile:Bool;
	public var previousPosition:FlxPoint;

	public function new(x:Float, y:Float, actorData:ActorData) {
		super(x, y);
		data = actorData;
		create();
		assignStats();
		setupGraphics();
	}

	public function create() {}

	public function setupGraphics() {}

	/**
	 * Assigns all the stats that come directly from Depot for each actor.
	 */
	public function assignStats() {
		if (data != null) {
			name = data.name;
			health = data.health;
			atk = data.atk;
			def = data.def;
			spd = data.spd;
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	public function updateMovement(elapsed:Float) {
		if (moveToNextTile) {
			switch (moveDirection) {
				case UP:
					y -= Globals.MOVEMENT_SPEED;
				case DOWN:
					y += Globals.MOVEMENT_SPEED;
				case LEFT:
					x -= Globals.MOVEMENT_SPEED;
				case RIGHT:
					x += Globals.MOVEMENT_SPEED;
			}
		}

		if ((x % Globals.TILE_SIZE == 0) && (y % Globals.TILE_SIZE == 0)) {
			moveToNextTile = false;
			previousPosition = this.getPosition();
		}
	}

	public function moveTo(direction:MoveDirection) {
		if (!moveToNextTile) {
			moveDirection = direction;
			moveToNextTile = true;
		}
	}

	public function resetPosition() {
		if (previousPosition != null) {
			this.setPosition(previousPosition.x, previousPosition.y);
		}
	}
}