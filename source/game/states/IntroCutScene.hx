package game.states;

class IntroCutScene extends CutsceneState {
	public function new() {
		super(new LevelOne(), [
			{
				text: 'In our small village, there exists a myth.',
				delay: 5
			},
			{
				text: 'Anone who can obtain a lotus from the bottom of the well...',
				delay: 5
			},
			{text: 'their wish will be granted.', delay: 5}
		]);
	}
}