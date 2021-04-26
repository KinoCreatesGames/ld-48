package game.states;

class LevelFour extends LevelState {
	override public function create() {
		super.create();
		createLevel('0005_Level_4');
	}

	override public function gotoNextLevel() {
		FlxG.switchState(new LevelFive());
	}
}