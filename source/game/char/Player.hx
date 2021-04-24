package game.char;

import game.char.Actor.MoveDirection;
import flixel.ui.FlxVirtualPad;

class Player extends Actor {
	#if mobile
	var _virtualPad:FlxVirtualPad;
	#end

	override function setupGraphics() {
		makeGraphic(8, 8, KColor.WHITE);
		createVirtualPad();
	}

	public function createVirtualPad() {
		#if mobile
		_virtualPad = new FlxVirtualPad(FULL, NONE);
		_virtualPad.alpha = 0.5;
		FlxG.state.add(_virtualPad);
		#end
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
		if (FlxG.keys.anyPressed([DOWN, S])) {
			moveTo(MoveDirection.DOWN);
		} else if (FlxG.keys.anyPressed([UP, W])) {
			moveTo(MoveDirection.UP);
		} else if (FlxG.keys.anyPressed([LEFT, A])) {
			moveTo(MoveDirection.LEFT);
		} else if (FlxG.keys.anyPressed([RIGHT, D])) {
			moveTo(MoveDirection.RIGHT);
		}
		#end
		this.bound();
	}
}