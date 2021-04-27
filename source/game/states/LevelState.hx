package game.states;

import game.objects.Lotus;
import game.objects.Fly;
import game.objects.Chest;
import game.objects.Hole;
import flixel.FlxObject;
import game.ui.PlayerHUD;
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
	var FLY = 4;
	var WALL = 5;
	var LOTUS = 6;
}

enum abstract CollisionTiles(Int) from Int to Int {
	var WALL_TOP = 44;
	var INNER_WALL = 86;
	var INNER_WALL_BOT = 125;
	var FLOOR = 465;
	var FLOOR2 = 505;
	var FLOOR3 = 464;
}

enum abstract EntityTypes(String) from String to String {
	var CHEST = 'Chest';
	var ENEMY = 'Enemy';
}

class LevelState extends BaseTileState {
	// Single Objects
	public var player:Player;
	public var playerHUD:PlayerHUD;

	// Groups
	public var collectibleGrp:FlxTypedGroup<Collectible>;
	public var enemyBulletGrp:FlxTypedGroup<Bullet>;
	public var holeGrp:FlxTypedGroup<Hole>;
	public var chestGrp:FlxTypedGroup<Chest>;
	public var wallGrp:FlxTypedGroup<FlxSprite>;
	public var flyGroup:FlxTypedGroup<FlxSprite>;
	public var lotusGroup:FlxTypedGroup<FlxSprite>;

	// Sounds
	public var pauseInSound:FlxSound;
	public var impactSound:FlxSound;
	public var wallImpactSound:FlxSound;
	public var flySound:FlxSound;
	public var holeFallSound:FlxSound;
	public var levelMusic:FlxSound;

	override public function createGroups() {
		super.createGroups();
		createSounds();
		createEnemyGroups();
		createPlayer();
		createInteractableGroups();
	}

	override public function addGroups() {
		super.addGroups();
		// add(regionGrp);
		add(player);
		add(enemyBulletGrp);
		add(holeGrp);
		add(chestGrp);
		add(collectibleGrp); // Doesn't work with collectibles?
		add(wallGrp);
		add(flyGroup);
		add(lotusGroup);
		// add(packageGrp);
		add(playerHUD);
	}

	public function createSounds() {
		pauseInSound = FlxG.sound.load(AssetPaths.pause_in_new__wav);
		impactSound = FlxG.sound.load(AssetPaths.enemy_impact2__wav);
		wallImpactSound = FlxG.sound.load(AssetPaths.wall_impact__wav);
		flySound = FlxG.sound.load(AssetPaths.wing_sound__wav);
		holeFallSound = FlxG.sound.load(AssetPaths.hole_fall_sound__wav);
		if (FlxG.sound.music != null && FlxG.sound.music.playing == false) {
			FlxG.sound.playMusic(AssetPaths.DarkWinds__OGG, 0.65, true);
		}
		if (FlxG.sound.music == null) {
			FlxG.sound.playMusic(AssetPaths.DarkWinds__OGG, 0.65, true);
		}
	}

	public function createEnemyGroups() {
		enemyBulletGrp = new FlxTypedGroup<Bullet>(50);
	}

	public function createPlayer() {
		player = new Player(0, 0, null);
		player.health = getHealth();
		var save = new FlxSave();
		if (save.bind('position')) {
			var position = save.data.position;

			if (position != null) {
				player.setPosition(position.x, position.y);
			}
			save.close();
		}
	}

	public function createInteractableGroups() {
		wallGrp = new FlxTypedGroup<FlxSprite>();
		collectibleGrp = new FlxTypedGroup<Collectible>();
		chestGrp = new FlxTypedGroup<Chest>();
		holeGrp = new FlxTypedGroup<Hole>();
		flyGroup = new FlxTypedGroup<FlxSprite>();
		lotusGroup = new FlxTypedGroup<FlxSprite>();
	}

	override public function createUI() {
		super.createUI();
		playerHUD = new PlayerHUD(0, 0, player);
	}

	override public function createLevelInformation() {
		var tileLayer:TiledTileLayer = cast map.getLayer('Floor');
		var regionLayer:TiledTileLayer = cast map.getLayer('Regions');
		var regionTileset:TiledTileSet = map.getTileSet('Regions');
		var entityLayer:TiledObjectLayer = cast map.getLayer('Entities');
		var autoTileLayer:TiledTileLayer = cast map.getLayer('FloorAuto');

		createTurnAction();
		createLevelMap(tileLayer, autoTileLayer);
		setupLevelTileProperties();
		createRegionEntities(regionLayer, regionTileset);
		createTiledEntities(entityLayer);
	}

	public function setupLevelTileProperties() {
		var tileset = map.getTileSet('TilesClean');

		[WALL_TOP, INNER_WALL_BOT, INNER_WALL].iter((collId) -> {
			gameLvl.setTileProperties(collId + tileset.firstGID, FlxObject.ANY);
		});
		[FLOOR, FLOOR2, FLOOR3].iter((collId) -> {
			gameLvl.setTileProperties(collId + tileset.firstGID,
				FlxObject.NONE);
		});
	}

	public function createTurnAction() {
		player.actionNotify.add((action) -> {
			updateTurn();
		});
	}

	public function updateTurn() {
		// Update Turn For All Game Elements

		enemyGrp.members.iter((enemy) -> {
			enemy.startPhase();
		});
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
					var save = new FlxSave();
					if (save.bind('position')) {
						var position = save.data.position;
						if (position == null) {
							player.setPosition(coords.x, coords.y);
						}
						save.close();
					}

				case CRACK:
				// Create Crack Here as individual sprite sheet
				// var sprite = new Goal(coords.x, coords.y);
				// regionGrp.add(sprite);
				case FALL:
					// Create Fall Here As Individual SpriteSheet
					var hole = new Hole(coords.x, coords.y);
					holeGrp.add(hole);
				case FLY:
					var fly = new Fly(coords.x, coords.y);
					var spr = new FlxSprite(coords.x, coords.y);
					// spr.makeGraphic(32, 32, KColor.WHITE);
					spr.loadGraphic(AssetPaths.fly__png, false, 32, 32);
					collectibleGrp.add(fly);
					flyGroup.add(fly);
					flyGroup.add(spr);
				// collectibleGrp.add(cast spr);
				case WALL:
					var wall = new FlxSprite(coords.x, coords.y);
					wall.makeGraphic(32, 32, KColor.TRANSPARENT);
					wallGrp.add(wall);
				case LOTUS:
					var lotus = new FlxSprite(coords.x, coords.y);
					lotus.loadGraphic(AssetPaths.Lotus__png);
					lotusGroup.add(lotus);
			}
		}
	}

	public function createTiledEntities(entities:TiledObjectLayer) {
		entities.objects.iter((entity) -> {
			switch (entity.name) {
				case ENEMY:
					var enemy = new Grunt(entity.x, entity.y,
						getPoints(entity), null);
					enemyGrp.add(enemy);
				case CHEST:
					// Create Chest
					var chest = new Chest(entity.x, entity.y);
					chestGrp.add(chest);
				case _:
					// Do nothing
			}
		});
	}

	private function getPoints(tiledObject:TiledObject) {
		var points = [];
		for (key => value in tiledObject.properties.keys) {
			if (key.contains('Path')) {
				var xy = tiledObject.properties.get(key).split(",").map(num -> {
					Std.parseFloat(num);
				});
				points.push(new FlxPoint(xy[0] * map.tileWidth,
					xy[1] * map.tileHeight));
			}
		}
		return points;
	}

	override public function processCollision() {
		super.processCollision();
		FlxG.overlap(player, collectibleGrp, playerTouchCollectible);
		FlxG.overlap(player.swordHitBox, null, playerSwordTouchGrass);
		FlxG.overlap(player, holeGrp, playerTouchHole);
		FlxG.overlap(player, flyGroup, playerTouchFly);
		FlxG.overlap(player, lotusGroup, playerTouchLotus);
		FlxG.collide(player, enemyGrp, (plyr:Player, enemy:Enemy) -> {
			plyr.moveToNextTile = false;
			enemy.moveToNextTile = false;
			impactSound.play();
			plyr.resetPosition();
			enemy.resetPosition();
			plyr.takeDamage(1);
		});
		if (lvlGrp.visible) {
			FlxG.collide(player, lvlGrp, (plyr:Player, lvl) -> {
				wallImpactSound.play();
				plyr.moveToNextTile = false;
				plyr.resetPosition();
			});
			FlxG.collide(enemyGrp, lvlGrp);
		}
		FlxG.collide(enemyGrp, wallGrp);
		FlxG.collide(player, wallGrp, (plyr:Player, lvl) -> {
			wallImpactSound.play();
			plyr.moveToNextTile = false;
			plyr.resetPosition();
		});
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
			case Fly:
				var save = new FlxSave();
				save.bind('position');
				var pos = collectible.getPosition();
				save.data.position = new FlxPoint(pos.x,
					collectible.initialY - 6);
				save.close();
				if (flySound.playing == false) {
					flySound.play();
				}
				FlxG.camera.fade(KColor.BLACK, 1, false, () -> {
					gotoPreviousLevel();
					FlxG.camera.fade(KColor.BLACK, 1, true);
				});
			case Lotus:
				// Complete the game
				completeLevel = true;
				// Different Final Text Based on how much health
				// you have left
		}
	}

	public function playerTouchFly(player:Player, fly:FlxSprite) {
		var save = new FlxSave();
		save.bind('position');
		var pos = fly.getPosition();
		save.data.position = new FlxPoint(pos.x, pos.y);
		save.close();
		if (flySound.playing == false) {
			flySound.play();
		}
		FlxG.camera.fade(KColor.BLACK, 1, false, () -> {
			gotoPreviousLevel();
			FlxG.camera.fade(KColor.BLACK, 1, true);
		});
	}

	public function playerTouchLotus(player:Player, lotus:FlxSprite) {
		completeLevel = true;
	}

	public function playerTouchHole(player:Player, hole:Hole) {
		// Move Down a level & Save Player current position
		// Use that position as the new spawn point.

		var save = new FlxSave();
		save.bind('position');
		save.data.position = hole.getPosition();
		save.close();
		if (holeFallSound.playing == false) {
			holeFallSound.play();
		}
		FlxG.camera.fade(KColor.BLACK, 1, false, () -> {
			gotoNextLevel();
			FlxG.camera.fade(KColor.BLACK, 1, true);
		});
	}

	public function gotoNextLevel() {}

	public function gotoPreviousLevel() {}

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
		processPause(elapsed);
		processCompleteLevel(elapsed);
		processGameOver(elapsed);
	}

	public function processPause(elapsed:Float) {
		if (FlxG.keys.anyJustPressed([ESCAPE])) {
			openSubState(new PauseSubState());
		}
	}

	public function processCompleteLevel(elapsed:Float) {
		if (completeLevel) {
			// openSubState();
			FlxG.switchState(new EndGameState());
			// Trigger Cutscene here
		}
	}

	public function processGameOver(elapsed:Float) {
		if (player.health <= 0) {
			openSubState(new GameOverSubState());
		}
	}

	public function levelTime() {
		return 300;
	}

	public override function tilesetPath() {
		return AssetPaths.TilesClean__png;
	}

	inline function getHealth() {
		var healthSave = new FlxSave();
		healthSave.bind('health');
		var playerHealth = healthSave.data.health;
		healthSave.close();
		return playerHealth;
	}
}