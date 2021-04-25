package game.objects;

class Chest extends FlxSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
		// Replace with sprite sheet element
		makeGraphic(32, 32, KColor.YELLOW);
	}
}