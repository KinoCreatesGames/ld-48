package game.states;

class DebugState extends LevelState {
	override public function create() {
		super.create();
		createLevel('Level_0');
	}
}