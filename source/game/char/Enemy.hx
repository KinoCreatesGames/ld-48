package game.char;

import game.char.Actor.MoveDirection;
import flixel.FlxObject;
import flixel.util.FlxPath;
import flixel.math.FlxVelocity;

class Enemy extends game.char.Actor {
	public var walkPath:Array<FlxPoint>;
	public var points:Int;
	public var ai:State;
	public var currentNode:FlxPoint;

	public function new(x:Float, y:Float, path:Array<FlxPoint>,
			monsterData:MonsterData) {
		super(x, y, monsterData);
		walkPath = path;
		if (monsterData != null) {
			points = monsterData.points;
		}

		ai = new State(idle);
		this.path = new KPath(path);
		this.path.start(null, (Globals.MOVEMENT_SPEED * 8),
			FlxPath.LOOP_FORWARD, false);
		this.path.active = false;
	}

	public function idle(elapsed:Float) {
		// Set up seeing player logic
	}

	public function moving(elapsed:Float) {
		if (moveToNextTile == false) {
			ai.currentState = idle;
		} else {
			var currentPoint = this.path.activePathNode();
			updateFacingRelationToPoint(currentPoint);
		}
		updateMovement(elapsed);
	}

	public function startPhase() {
		if (this.path.activePathNode() != null) {
			currentNode = this.path.activePathNode()
				.copyTo(FlxPoint.weak(0, 0));
			updateFacingRelationToPoint(currentNode);
			moveTo(facingToDirection());
			moveToNextTile = true;
			ai.currentState = moving;
		}
	}

	public function facingToDirection() {
		return switch (facing) {
			case FlxObject.LEFT:
				MoveDirection.LEFT;
			case FlxObject.RIGHT:
				MoveDirection.RIGHT;
			case FlxObject.DOWN:
				MoveDirection.DOWN;
			case FlxObject.UP:
				MoveDirection.UP;
			case _:
				MoveDirection.LEFT;
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		ai.update(elapsed);
		updatePathing(elapsed);
	}

	override public function updateMovement(elapsed:Float) {
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
		// if (currentNode != null
		// 	&& !currentNode.equals(this.path.activePathNode())) {
		// 	moveToNextTile = false;
		// }
		if ((x % Globals.TILE_SIZE == 0) && (y % Globals.TILE_SIZE == 0)) {
			moveToNextTile = false;
			previousPosition = this.getPosition();
			if (currentNode.equals(this.getPosition())) {
				// Assign new Node
				this.path.setNode((this.path.nodeIndex) % this.path.nodes.length);
				currentNode = this.path.activePathNode()
					.copyTo(FlxPoint.weak(0, 0));
			}
		}
	}

	public function updatePathing(elapsed:Float) {
		if (moveToNextTile) {
			// this.path.active = true;
			// this.path.start(null, (Globals.MOVEMENT_SPEED * 8),
			// 	FlxPath.LOOP_FORWARD, false);
		} else {
			// this.path.cancel();
		}
	}

	public function updateFacingRelationToPoint(point:FlxPoint) {
		var copy = point.copyTo(FlxPoint.weak(0, 0));
		var heightDiff = 30;
		var diffPoint = copy.subtractPoint(this.getPosition());
		var left = diffPoint.x < 0;
		var right = diffPoint.x > 0;
		var up = diffPoint.y < heightDiff.negate();
		var down = diffPoint.y > heightDiff;
		if (up) {
			facing = FlxObject.UP;
		} else if (down) {
			facing = FlxObject.DOWN;
		} else if (left) {
			facing = FlxObject.LEFT;
		} else if (right) {
			facing = FlxObject.RIGHT;
		}
	}
}