package game.objects;

class Fly extends Collectible {
	public function new(x:Float, y:Float) {
		super(x, y);
	}

	override public function setSprite() {
		loadGraphic(AssetPaths.fly__png, false, 32, 32, true);
		trace(AssetPaths.fly__png);
		// makeGraphic(32, 32, KColor.WHITE);
	}
}