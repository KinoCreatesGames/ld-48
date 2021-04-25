package game.states;

class LevelThree extends LevelState {
	override public function create() {
		super.create();
		createLevel("0004_Level_3");
	}

	override public function gotoNextLevel() {
		FlxG.switchState(new LevelFour());
	}
}