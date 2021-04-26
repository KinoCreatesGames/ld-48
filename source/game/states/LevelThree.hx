package game.states;

class LevelThree extends LevelState {
	override public function create() {
		super.create();
		createLevel("0003_Level_2");
	}

	override public function gotoNextLevel() {
		FlxG.switchState(new LevelFour());
	}
}