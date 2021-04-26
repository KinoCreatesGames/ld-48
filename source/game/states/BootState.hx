package game.states;

class BootState extends FlxState {
	override public function create() {
		super.create();
		var save = new FlxSave();
		save.bind('position');
		save.erase();
		var healthSave = new FlxSave();
		healthSave.bind('health');
		healthSave.data.health = 3;
		healthSave.close();
		FlxG.switchState(new TitleState());
	}
}