package game.states;

class LevelTwo extends LevelState {
	override public function create() {
		super.create();
		createLevel('0003_Level_2');
	}

	override public function gotoNextLevel() {
		FlxG.switchState(new LevelThree());
	}

	override public function gotoPreviousLevel() {
		FlxG.switchState(new LevelOne());
	}
}