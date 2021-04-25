package game.states;

class LevelOne extends LevelState {
	override public function create() {
		super.create();
		createLevel('0004_Level_1');
		lvlGrp.visible = false;
	}

	override public function gotoNextLevel() {
		FlxG.switchState(new LevelTwo());
	}
}