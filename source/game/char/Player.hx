package game.char;

import flixel.util.FlxSignal;
import flixel.FlxObject;
import game.char.Actor.MoveDirection;
import flixel.ui.FlxVirtualPad;

enum Action {
	Attack;
	Move;
}

class Player extends Actor {
	public var hasSword:Bool = false;
	public var hasShield:Bool = false;
	public var hasWizardBag:Bool = false;
	public var hasHook:Bool = false;
	public var actionNotify:FlxTypedSignal<Action -> Void>;

	public var swordHitBox:FlxSprite;

	#if mobile
	var _virtualPad:FlxVirtualPad;
	#end

	override public function create() {
		actionNotify = new FlxTypedSignal<Action -> Void>();
	}

	override public function setupGraphics() {
		makeGraphic(8, 8, KColor.WHITE);
		createVirtualPad();
		createSword();
	}

	public function createVirtualPad() {
		#if mobile
		_virtualPad = new FlxVirtualPad(FULL, NONE);
		_virtualPad.alpha = 0.5;
		FlxG.state.add(_virtualPad);
		#end
	}

	public function createSword() {
		var pos = this.getPosition();
		var size = Globals.TILE_SIZE;
		swordHitBox = new FlxSprite(pos.x, pos.y);
		swordHitBox.makeGraphic(size, size, KColor.PRETTY_PINK);
		FlxG.state.add(swordHitBox);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (hasSword) {
			processSwordPowerUp(elapsed);
		}
	}

	public function processSwordPowerUp(elapsed:Float) {
		var attack = FlxG.keys.anyJustPressed([Z]);
		var playerMidPoint = this.getMidpoint();
		var newPosition = playerMidPoint.copyTo(FlxPoint.weak(0, 0));
		var offSet = this.width / 2;
		var tileSize = Globals.TILE_SIZE;
		if (attack) {
			// Attack in front of the player
			switch (facing) {
				case FlxObject.LEFT:
					newPosition.y -= offSet;
					newPosition.x -= (offSet + tileSize);
				case FlxObject.RIGHT:
					newPosition.y -= offSet;
					newPosition.x += offSet;
				case FlxObject.UP:
					newPosition.x -= offSet;
					newPosition.y -= (offSet + tileSize);
				case FlxObject.DOWN:
					newPosition.x -= offSet;
					newPosition.y += (offSet);
			}
			trace('moved sword hit box');
			swordHitBox.setPosition(newPosition.x, newPosition.y);
			// Action Signal
			actionNotify.dispatch(Attack);
		}
	}

	override public function updateMovement(elapsed) {
		super.updateMovement(elapsed);
		#if mobile
		if (_virtualPad.buttonDown.pressed) {
			moveTo(MoveDirection.DOWN);
		} else if (_virtualPad.buttonUp.pressed) {
			moveTo(MoveDirection.UP);
		} else if (_virtualPad.buttonLeft.pressed) {
			moveTo(MoveDirection.LEFT);
		} else if (_virtualPad.buttonRight.pressed) {
			moveTo(MoveDirection.RIGHT);
		}
		#else
		// Check for WASD or arrow key presses and move accordingly
		if (FlxG.keys.anyJustPressed([DOWN, S])) {
			moveTo(MoveDirection.DOWN);
			facing = FlxObject.DOWN;
		} else if (FlxG.keys.anyJustPressed([UP, W])) {
			moveTo(MoveDirection.UP);
			facing = FlxObject.UP;
		} else if (FlxG.keys.anyJustPressed([LEFT, A])) {
			moveTo(MoveDirection.LEFT);
			facing = FlxObject.LEFT;
		} else if (FlxG.keys.anyJustPressed([RIGHT, D])) {
			moveTo(MoveDirection.RIGHT);
			facing = FlxObject.RIGHT;
		}
		#end
		this.bound();
	}

	override public function moveTo(direction:MoveDirection) {
		super.moveTo(direction);
		actionNotify.dispatch(Move);
	}
}