package game.states;

class IntroCutScene extends CutsceneState {
	public function new() {
		super(new LevelOne(), [
			{
				text: 'In our small village, there exists a myth. Anyone who can obtain a lotus from the bottom of the well...their wish will be granted.',
				delay: 5
			}
		]);
	}
}