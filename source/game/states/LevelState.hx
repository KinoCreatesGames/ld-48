package game.states;

import game.objects.Shield;
import game.objects.Sword;
import game.objects.Hook;
import game.objects.WizardBag;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledTileLayer;
import game.objects.Collectible;

enum abstract RegionId(Int) from Int to Int {
	var SPAWN = 0;
	var CRACK = 1;
	var FALL = 2;
	var LEAF = 3;
}

class LevelState extends BaseTileState {
	// Single Objects
	public var player:Player;

	// Groups
	public var collectibleGrp:FlxTypedGroup<Collectible>;

	override public function createGroups() {
		super.createGroups();
		createSounds();
		createPlayer();
	}

	override public function addGroups() {
		super.addGroups();
		// add(regionGrp);
		add(player);
		// add(packageGrp);
		// add(playerHUD);
	}

	public function createSounds() {}

	public function createPlayer() {
		player = new Player(0, 0, null);
	}

	override public function createUI() {
		super.createUI();
	}

	override public function createLevelInformation() {
		var tileLayer:TiledTileLayer = cast map.getLayer('Floor');
		var regionLayer:TiledTileLayer = cast map.getLayer('Regions');
		var regionTileset:TiledTileSet = map.getTileSet('Regions');
		var entityLayer:TiledObjectLayer = cast map.getLayer('Entities');
		var autoTileLayer:TiledTileLayer = cast map.getLayer('FloorAuto');

		createTurnAction();
		createLevelMap(tileLayer, autoTileLayer);
		createRegionEntities(regionLayer, regionTileset);
		createTiledEntities(entityLayer);
	}

	public function createTurnAction() {
		player.actionNotify.add((action) -> {
			updateTurn();
		});
	}

	public function updateTurn() {
		// Update Turn For All Game Elements
		trace('Turn Update');

		// Turn Updates For Everybody
		// Player can finally move again
		player.resetState();
	}

	public function createRegionEntities(regions:TiledTileLayer,
			tileset:TiledTileSet) {
		var regionLevel = new FlxTilemap();
		regionLevel.loadMapFromArray(regions.tileArray, map.width, map.height,
			AssetPaths.Regions__intgrid__png, map.tileWidth, map.tileHeight,
			FlxTilemapAutoTiling.OFF, tileset.firstGID, 1);
		for (index in 0...regionLevel.getData().length) {
			var tile = regionLevel.getTileByIndex(index);
			var coords = regionLevel.getTileCoordsByIndex(index, false);
			var tileId = tile - tileset.firstGID;
			switch (tileId) {
				case SPAWN:
					// Set the player position on spawning
					player.setPosition(coords.x, coords.y);
				case CRACK:
				// Create Crack Here as individual sprite sheet
				// var sprite = new Goal(coords.x, coords.y);
				// regionGrp.add(sprite);
				case FALL:
					// Create Fall Here As Individual SpriteSheet
			}
		}
	}

	public function createTiledEntities(entities:TiledObjectLayer) {}

	override public function processCollision() {
		super.processCollision();
		FlxG.overlap(player, collectibleGrp, playerTouchCollectible);
		FlxG.overlap(player.swordHitBox, null, playerSwordTouchGrass);
	}

	public function playerTouchCollectible(player:Player,
			collectible:Collectible) {
		var collectibleClass = Type.getClass(collectible);
		switch (collectibleClass) {
			case Sword:
				player.hasSword = true;
			case Shield:
				player.hasShield = true;
			case WizardBag:
				player.hasWizardBag = true;
			case Hook:
				player.hasHook = true;
		}
	}

	// TODO: Change to cuttable object
	public function playerSwordTouchGrass(sword:FlxSprite,
			cuttable:FlxSprite) {
		if (sword.visible) {
			// Do Damage or cut grass
			// Hit Box Disappears
			if (cuttable != null) {
				cuttable.kill();
			}
			// Hit box disappears
			sword.visible = false;
		}
	}

	override public function processLevel(elapsed:Float) {
		super.processLevel(elapsed);
	}

	public function levelTime() {
		return 300;
	}

	public override function tilesetPath() {
		return AssetPaths.MRMOTEXT__png;
	}
}