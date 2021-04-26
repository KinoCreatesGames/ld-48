package game.states;

class LevelOne extends LevelState {
	override public function create() {
		super.create();
		var bg = new FlxSprite(0, 0);
		bg.loadGraphic(AssetPaths.v3Clean__png);
		add(bg);
		createLevel('0004_Level_1');
		lvlGrp.visible = false;
	}

	override public function gotoNextLevel() {
		FlxG.switchState(new LevelTwo());
	}
}