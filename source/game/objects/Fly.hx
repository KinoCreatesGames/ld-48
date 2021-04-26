package game.objects;

class Fly extends Collectible {
	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic(AssetPaths.wing__png, false, 32, 32, true);
	}
}