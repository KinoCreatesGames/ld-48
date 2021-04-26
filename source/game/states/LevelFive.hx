package game.states;

class LevelFive extends LevelState {
	override public function create() {
		super.create();
		createLevel('0007_Level_6');
	}

	override public function gotoPreviousLevel() {
		FlxG.switchState(new LevelFour());
	}

	override public function gotoNextLevel() {
		FlxG.switchState(new LevelSix());
	}
}