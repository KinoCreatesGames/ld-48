package game.states;

class BootState extends FlxState {
	override public function create() {
		super.create();
		var save = new FlxSave();
		save.bind('position');
		save.erase();
		FlxG.switchState(new LevelOne());
	}
}