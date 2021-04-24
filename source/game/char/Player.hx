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
	public var canTakeAction:Bool = true;
	public var shielded:Bool = false;

	public var swordHitBox:FlxSprite;

	#if mobile
	var _virtualPad:FlxVirtualPad;
	#end

	override public function create() {
		actionNotify = new FlxTypedSignal<Action -> Void>();
	}

	override public function setupGraphics() {
		loadGraphic(AssetPaths.Player__png, true, 32, 32, true);
		var fRate = 6;
		animation.add('idle', [0], fRate);
		animation.add('idle_up', [8], fRate);
		animation.add('idle_left', [4], fRate);
		animation.add('idle_right', [6], fRate);
		animation.add('run_down', [1, 0, 2], fRate);
		animation.add('run_left', [4, 5], fRate);
		animation.add('run_right', [6, 7], fRate);
		animation.add('run_up', [8, 9, 10], fRate);
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
		if (hasShield) {
			processShieldPowerUp(elapsed);
		}
	}

	public function processShieldPowerUp(elapsed:Float) {
		var shield = FlxG.keys.anyJustPressed([X]);
		if (shield && canTakeAction) {
			shielded = true;
		}
	}

	public function processSwordPowerUp(elapsed:Float) {
		var attack = FlxG.keys.anyJustPressed([Z]);
		var playerMidPoint = this.getMidpoint();
		var newPosition = playerMidPoint.copyTo(FlxPoint.weak(0, 0));
		var offSet = this.width / 2;
		var tileSize = Globals.TILE_SIZE;
		if (attack && canTakeAction) {
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
			startAction(Attack);
		}
	}

	override public function updateMovement(elapsed) {
		super.updateMovement(elapsed);
		if (canTakeAction) {
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
		}
		updateAnim(elapsed);
		this.bound();
	}

	public function updateAnim(elapsed:Float) {
		if (moveToNextTile) {
			switch (facing) {
				case FlxObject.LEFT:
					animation.play('run_left');
				case FlxObject.RIGHT:
					animation.play('run_right');
				case FlxObject.UP:
					animation.play('run_up');
				case FlxObject.DOWN:
					animation.play('run_down');
			}
		} else {
			switch (facing) {
				case FlxObject.LEFT:
					animation.play('idle_left');
				case FlxObject.RIGHT:
					animation.play('idle_right');
				case FlxObject.UP:
					animation.play('idle_up');
				case FlxObject.DOWN:
					animation.play('idle');
			}
		}
	}

	public function startAction(action:Action) {
		canTakeAction = false;
		actionNotify.dispatch(action);
	}

	public function resetState() {
		shielded = false;
		canTakeAction = true;
	}

	override public function moveTo(direction:MoveDirection) {
		super.moveTo(direction);
		startAction(Move);
	}
}