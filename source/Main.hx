package;

import game.states.BootState;
import game.states.LevelTwo;
import game.states.LevelOne;
import game.states.DebugState;
import flixel.FlxGame;
import openfl.display.Sprite;
import game.states.PlayState;

class Main extends Sprite {
	public function new() {
		super();
		addChild(new FlxGame(0, 0, BootState));
	}
}