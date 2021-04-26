package game.states;

class EndGameState extends CutsceneState {
	public function new() {
		var stdDelay = 5;
		super(new TitleState(), [
			{
				text: 'And so the young individual after facing many hardships, was finally able to get their wish granted.',
				delay: stdDelay
			},
			{text: 'Thank you for playing!', delay: 5}
		]);
	}
}