package game.states;

class LevelThree extends LevelState {
	override public function create() {
		super.create();
		createLevel("0005_Level_4");
	}

	override public function gotoPreviousLevel() {
		FlxG.switchState(new LevelTwo());
	}

	override public function gotoNextLevel() {
		FlxG.switchState(new LevelFour());
	}
}