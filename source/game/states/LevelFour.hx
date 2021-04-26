package game.states;

class LevelFour extends LevelState {
	override public function create() {
		super.create();
		createLevel('0006_Level_5');
	}

	override public function gotoNextLevel() {
		FlxG.switchState(new LevelFive());
	}
}