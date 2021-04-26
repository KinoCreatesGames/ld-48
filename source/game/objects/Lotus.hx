package game.objects;

class Lotus extends Collectible {
	public function new(x:Float, y:Float) {
		super(x, y);
	}

	override public function setSprite() {
		loadGraphic(AssetPaths.Lotus__png, false, 32, 32);
	}
}