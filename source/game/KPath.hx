package game;

import flixel.util.FlxPath;

class KPath extends FlxPath {
	override public function advancePath(Snap:Bool = false):FlxPoint {
		return super.advancePath(false);
	}
}