package game.ui;

class PlayerHUD extends FlxTypedGroup<FlxSprite> {
	public var position:FlxPoint;
	public var player:Player;

	public function new(x:Float, y:Float, player:Player) {
		super();
		position = new FlxPoint(x, y);
		this.player = player;
		this.create();
	}

	public function create() {
		// Create Other UI elements
		lockUI();
	}

	public function lockUI() {
		this.members.iter((member) -> {
			member.scrollFactor.set(0, 0);
		});
	}
}