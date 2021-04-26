package game.states;

class EndGameState extends CutsceneState {
	public function new() {
		var stdDelay = 5;
		super(new TitleState(), [
			{text: 'And so the young man was able to reconnect with his lover.',
				delay: stdDelay},
			{text: '', delay: 5}
		]);
	}
}