package game.states;

class LevelOne extends LevelState {
	override public function create() {
		super.create();
		createLevel('0002_Level_1');
	}
}