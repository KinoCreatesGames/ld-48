package game.objects;

class Fly extends Collectible {
	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(16, 16, KColor.WHITE);
	}
}