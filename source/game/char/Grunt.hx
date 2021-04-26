package game.char;

import flixel.FlxObject;

class Grunt extends Enemy {
	override public function setSprite() {
		loadGraphic(AssetPaths.Enemy__png, true, 32, 32, true);
		var fRate = 6;
		animation.add('idle', [1, 0, 2], fRate);
		animation.add('idle_up', [9, 8, 10], fRate);
		animation.add('idle_right', [5, 4, 5], fRate);
		animation.add('idle_left', [7, 6, 7], fRate);
		animation.add('run_down', [1, 0, 2], fRate);
		animation.add('run_right', [5, 4, 5], fRate);
		animation.add('run_left', [7, 6, 7], fRate);
		animation.add('run_up', [9, 8, 10], fRate);

		facing = FlxObject.DOWN;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateAnim(elapsed);
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
}