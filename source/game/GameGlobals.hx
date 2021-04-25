package game;

class GameGlobals {
	public static var playerPosition:FlxPoint;

	public static function savePlayerPosition(player:Player) {
		playerPosition = player.getPosition().copyTo(FlxPoint.weak(0, 0));
	}
}