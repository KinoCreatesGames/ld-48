package game.objects;

class Hole extends FlxSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(32, 32, KColor.TRANSPARENT);
	}
}