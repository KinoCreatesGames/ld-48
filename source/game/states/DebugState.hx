package game.states;

class DebugState extends LevelState {
	override public function create() {
		super.create();
		createLevel('Level_0');
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (player != null && player.hasSword == false) {
			player.hasSword = true;
		}
	}
}