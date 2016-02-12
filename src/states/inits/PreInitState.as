package states.inits {
	import com.newgrounds.API;
	import com.newgrounds.APIEvent;
	import egg82.base.BasePreInitState;
	import egg82.engines.interfaces.IStateEngine;
	import egg82.engines.nulls.NullAudioEngine;
	import egg82.engines.nulls.NullModEngine;
	import egg82.enums.FileRegistryType;
	import egg82.enums.MouseCodes;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.enums.XboxButtonCodes;
	import egg82.events.util.FileDataUtilEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.registry.Registry;
	import egg82.utils.FileDataUtil;
	import egg82.utils.MathUtil;
	import egg82.utils.NetUtil;
	import egg82.utils.Util;
	import enums.AudioQualityType;
	import enums.CustomOptionsRegistryType;
	import enums.CustomServiceType;
	import enums.DifficultyType;
	import enums.GameType;
	import enums.ShapeQualityType;
	import enums.TextureQualityType;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import physics.high.BulletHighData;
	import physics.high.ExplosionHighData;
	import physics.high.PaddleHighData;
	import physics.high.SentryHighData;
	import physics.high.StarHighData;
	import physics.low.BulletLowData;
	import physics.low.ExplosionLowData;
	import physics.low.PaddleLowData;
	import physics.low.SentryLowData;
	import physics.low.StarLowData;
	import physics.medium.BulletMediumData;
	import physics.medium.ExplosionMediumData;
	import physics.medium.PaddleMediumData;
	import physics.medium.SentryMediumData;
	import physics.medium.StarMediumData;
	import physics.ultra.BulletUltraData;
	import physics.ultra.ExplosionUltraData;
	import physics.ultra.PaddleUltraData;
	import physics.ultra.SentryUltraData;
	import physics.ultra.StarUltraData;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class PreInitState extends BasePreInitState {
		//vars
		private var physicsRegistry:IRegistry;
		
		private var stateEngine:IStateEngine = ServiceLocator.getService(ServiceType.STATE_ENGINE) as IStateEngine;
		
		[Embed(source = "../../../res/font/note.ttf", fontName = "note", mimeType = "application/x-font", fontWeight = "normal", fontStyle = "normal", unicodeRange = "U+0020-U+007e", advancedAntiAliasing = "true", embedAsCFF = "false")]
		private static var NOTE:Class;
		[Embed(source = "../../../res/font/speech.ttf", fontName = "speech", mimeType = "application/x-font", fontWeight = "normal", fontStyle = "normal", unicodeRange = "U+0020-U+007e", advancedAntiAliasing = "true", embedAsCFF = "false")]
		private static var SPEECH:Class;
		
		private var part:uint = 0;
		private var totalParts:uint = 3;
		private var checked:uint = 0;
		private var retry:uint = 0;
		
		private var id:String = "36550:7oMQaUng";
		private var key:String = "6eJ8M5kiQGj9mZIDIXs2C1i3ouERVw23";
		
		private var fileDataUtil:FileDataUtil = new FileDataUtil();
		
		private var fileDataUtilObserver:Observer = new Observer();
		
		//constructor
		public function PreInitState() {
			
		}
		
		//public
		override public function create(args:Array = null):void {
			super.create(args);
			
			INIT_REGISTRY.setRegister("version", "0.1a");
			/*INIT_REGISTRY.setRegister("debug", false);
			INIT_REGISTRY.setRegister("memoryHandicap", null);
			(INIT_REGISTRY.getRegister("cpuHandicap") as Timer).stop();*/
			//ServiceLocator.provideService(ServiceType.AUDIO_ENGINE, NullAudioEngine);
			
			fileDataUtilObserver.add(onFileDataUtilObserverNotify);
			Observer.add(FileDataUtil.OBSERVERS, fileDataUtilObserver);
			
			ServiceLocator.provideService(CustomServiceType.GAME_OPTIONS_REGISTRY, Registry);
			
			API.debugMode = (INIT_REGISTRY.getRegister("debug") as Boolean) ? API.DEBUG_MODE_LOGGED_OUT : API.RELEASE_MODE;
			API.addEventListener(APIEvent.API_CONNECTED, onConnectEvent);
			API.addEventListener(APIEvent.ERROR_UNKNOWN, onConnectEvent);
			API.addEventListener(APIEvent.ERROR_TIMED_OUT, onConnectEvent);
			API.addEventListener(APIEvent.ERROR_SENDING_COMMAND, onConnectEvent);
			API.addEventListener(APIEvent.ERROR_COMMAND_FAILED, onConnectEvent);
			API.addEventListener(APIEvent.ERROR_BAD_RESPONSE, onConnectEvent);
			API.addEventListener(APIEvent.ERROR_HOST_BLOCKED, onConnectEvent);
			API.addEventListener(APIEvent.ERROR_NOT_CONNECTED, onConnectEvent);
			API.addEventListener(APIEvent.ERROR_NONE, onConnectEvent);
			API.connect(Starling.all[0].nativeOverlay, id, key);
			
			stateEngine.skipMultiplePhysicsUpdate = true;
			
			ServiceLocator.provideService(ServiceType.MOD_ENGINE, NullModEngine);
			ServiceLocator.provideService(CustomServiceType.PHYSICS_REGISTRY, Registry, false);
			
			physicsRegistry = ServiceLocator.getService(CustomServiceType.PHYSICS_REGISTRY) as IRegistry;
			
			physicsRegistry.setRegister("star_" + ShapeQualityType.ULTRA, new StarUltraData());
			physicsRegistry.setRegister("star_" + ShapeQualityType.HIGH, new StarHighData());
			physicsRegistry.setRegister("star_" + ShapeQualityType.MEDIUM, new StarMediumData());
			physicsRegistry.setRegister("star_" + ShapeQualityType.LOW, new StarLowData());
			
			physicsRegistry.setRegister("explosion_" + ShapeQualityType.ULTRA, new ExplosionUltraData());
			physicsRegistry.setRegister("explosion_" + ShapeQualityType.HIGH, new ExplosionHighData());
			physicsRegistry.setRegister("explosion_" + ShapeQualityType.MEDIUM, new ExplosionMediumData());
			physicsRegistry.setRegister("explosion_" + ShapeQualityType.LOW, new ExplosionLowData());
			
			physicsRegistry.setRegister("paddle_" + ShapeQualityType.ULTRA, new PaddleUltraData());
			physicsRegistry.setRegister("paddle_" + ShapeQualityType.HIGH, new PaddleHighData());
			physicsRegistry.setRegister("paddle_" + ShapeQualityType.MEDIUM, new PaddleMediumData());
			physicsRegistry.setRegister("paddle_" + ShapeQualityType.LOW, new PaddleLowData());
			
			physicsRegistry.setRegister("sentry_" + ShapeQualityType.ULTRA, new SentryUltraData());
			physicsRegistry.setRegister("sentry_" + ShapeQualityType.HIGH, new SentryHighData());
			physicsRegistry.setRegister("sentry_" + ShapeQualityType.MEDIUM, new SentryMediumData());
			physicsRegistry.setRegister("sentry_" + ShapeQualityType.LOW, new SentryLowData());
			
			physicsRegistry.setRegister("bullet_" + ShapeQualityType.ULTRA, new BulletUltraData());
			physicsRegistry.setRegister("bullet_" + ShapeQualityType.HIGH, new BulletHighData());
			physicsRegistry.setRegister("bullet_" + ShapeQualityType.MEDIUM, new BulletMediumData());
			physicsRegistry.setRegister("bullet_" + ShapeQualityType.LOW, new BulletLowData());
			
			REGISTRY_UTIL.setOption(OptionsRegistryType.PHYSICS, "shapeQuality", ShapeQualityType.ULTRA);
			REGISTRY_UTIL.setOption(OptionsRegistryType.VIDEO, "textureQuality", TextureQualityType.ULTRA);
			REGISTRY_UTIL.setOption(OptionsRegistryType.VIDEO, "screenShake", true);
			REGISTRY_UTIL.setOption(OptionsRegistryType.VIDEO, "animations", true);
			REGISTRY_UTIL.setOption(OptionsRegistryType.VIDEO, "compressTextures", true);
			REGISTRY_UTIL.setOption(OptionsRegistryType.AUDIO, "musicQuality", AudioQualityType.ULTRA);
			REGISTRY_UTIL.setOption(OptionsRegistryType.AUDIO, "ambientQuality", AudioQualityType.ULTRA);
			REGISTRY_UTIL.setOption(OptionsRegistryType.AUDIO, "sfxQuality", AudioQualityType.ULTRA);
			REGISTRY_UTIL.setOption(OptionsRegistryType.KEYS, "fire", [MouseCodes.LEFT]);
			REGISTRY_UTIL.setOption(OptionsRegistryType.CONTROLLER, "fire", [XboxButtonCodes.A]);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.GAMEPLAY, "autoFire", false);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.GAMEPLAY, "difficulty", DifficultyType.MEDIUM);
			
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "health", 6);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "nemesisImpulseRate", 250);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "nemesisImpulseChance", 0.5);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "fireRate", 750);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "minObjects", 2);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "remedySpawnRate", 10000);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "remedySpawnChance", 0.025);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "remedyTime", 6000);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "remedyPower", 4);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "reinforceSpawnRate", 10000);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "reinforceSpawnChance", 0.025);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "reinforceTime", 6000);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "reinforcePower", 1.5);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "reliefSpawnRate", 10000);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "reliefSpawnChance", 0.05);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "reliefPower", 1);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "stressSpawnRate", 7000);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "stressSpawnChance", 0.25);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "stressPower", 0.75);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "shieldedStressSpawnRate", 12000);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "shieldedStressSpawnChance", 0.15);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "shieldedStressPower", 0.75);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "explosiveStressSpawnRate", 11000);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "explosiveStressSpawnChance", 0.1);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "explosiveStressPower", 1);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "clusterStressNumber", 8);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.SETUP, "clusterStressPower", 0.25);
			
			NetUtil.loadExactPolicyFile("https://egg82.ninja/crossdomain.xml");
			REGISTRY_UTIL.setOption(OptionsRegistryType.NETWORK, "fileHosts", [
				"https://egg82.ninja/hosted/Comfort%202"
			]);
			
			fileDataUtil.create();
			checkHosts(part);
			
			REGISTRY_UTIL.setFont("note", NOTE);
			REGISTRY_UTIL.setFont("speech", SPEECH);
			
			trace("preInit");
		}
		override public function destroy():void {
			Observer.remove(FileDataUtil.OBSERVERS, fileDataUtilObserver);
			
			fileDataUtil.destroy();
			
			super.destroy();
		}
		
		override public function update(deltaTime:Number):void {
			super.update(deltaTime);
			
			resize();
		}
		
		//private
		private function onConnectEvent(e:APIEvent):void {
			if (API.connected || retry >= REGISTRY_UTIL.getOption(OptionsRegistryType.NETWORK, "maxRetry")) {
				API.removeEventListener(APIEvent.API_CONNECTED, onConnectEvent);
				API.removeEventListener(APIEvent.ERROR_UNKNOWN, onConnectEvent);
				API.removeEventListener(APIEvent.ERROR_TIMED_OUT, onConnectEvent);
				API.removeEventListener(APIEvent.ERROR_SENDING_COMMAND, onConnectEvent);
				API.removeEventListener(APIEvent.ERROR_COMMAND_FAILED, onConnectEvent);
				API.removeEventListener(APIEvent.ERROR_BAD_RESPONSE, onConnectEvent);
				API.removeEventListener(APIEvent.ERROR_HOST_BLOCKED, onConnectEvent);
				API.removeEventListener(APIEvent.ERROR_NOT_CONNECTED, onConnectEvent);
				API.removeEventListener(APIEvent.ERROR_NONE, onConnectEvent);
			} else {
				retry++;
				API.disconnect();
				Util.timedFunction(3000, API.connect, [Starling.all[0].nativeOverlay, id, key]);
			}
		}
		
		private function onFileDataUtilObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== fileDataUtil) {
				return;
			}
			
			checkHosts(part, event);
		}
		
		private function checkHosts(part:uint, event:String = null):void {
			this.part = part;
			setLoaded(part, totalParts);
			
			var localDir:String = INIT_REGISTRY.getRegister("url") as String;
			if (part == 0) {
				if (localDir && localDir.indexOf("file://") == -1) {
					localDir = null;
				}
				
				this.part = part = part + 1;
				setLoaded(part, totalParts);
				
				if (localDir) {
					fileDataUtil.getFile(localDir + "/data/check.txt");
					return;
				}
			}
			
			var fileHosts:Array = REGISTRY_UTIL.getOption(OptionsRegistryType.NETWORK, "fileHosts") as Array;
			if (part == 1) {
				if (event && event == FileDataUtilEvent.FILE_COMPLETE) {
					fileHosts = [localDir + "/data"];
					this.part = part = part + 2;
				} else {
					this.part = part = part + 1;
				}
				setLoaded(part, totalParts);
			}
			
			if (part == 2) {
				if (checked >= 1 && event == FileDataUtilEvent.FILE_ERROR) {
					fileHosts.splice(checked, 1);
					REGISTRY_UTIL.setOption(OptionsRegistryType.NETWORK, "fileHosts", fileHosts);
				} else {
					checked++;
				}
				
				if (checked < fileHosts.length) {
					fileDataUtil.getFile(fileHosts[checked] + "/check.txt");
					return;
				} else {
					this.part = part = part + 1;
					setLoaded(part, totalParts);
				}
			}
			
			if (part == totalParts) {
				var length:uint = fileHosts.length - 1;
				
				var methods:Array;
				var quality:String;
				
				var games:Array = Util.getEnums(GameType);
				var game:String;
				
				methods = Util.getEnums(TextureQualityType);
				for each (quality in methods) {
					REGISTRY_UTIL.setFile(FileRegistryType.TEXTURE, quality + "_anim", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/anim.png");
					REGISTRY_UTIL.setFile(FileRegistryType.TEXTURE, quality + "_background_menu", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/background_menu.jpg");
					REGISTRY_UTIL.setFile(FileRegistryType.TEXTURE, quality + "_background_menu_credits", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/background_menu_credits.jpg");
					REGISTRY_UTIL.setFile(FileRegistryType.TEXTURE, quality + "_background_menu_options", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/background_menu_options.jpg");
					REGISTRY_UTIL.setFile(FileRegistryType.TEXTURE, quality + "_background_menu_horde", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/background_menu_horde.jpg");
					REGISTRY_UTIL.setFile(FileRegistryType.TEXTURE, quality + "_background_menu_mask", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/background_menu_mask.jpg");
					REGISTRY_UTIL.setFile(FileRegistryType.TEXTURE, quality + "_background_menu_nemesis", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/background_menu_nemesis.jpg");
					REGISTRY_UTIL.setFile(FileRegistryType.TEXTURE, quality + "_background_menu_unity", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/background_menu_unity.jpg");
					for each (game in games) {
						REGISTRY_UTIL.setFile(FileRegistryType.TEXTURE, quality + "_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/" + game + ".png");
						REGISTRY_UTIL.setFile(FileRegistryType.TEXTURE, quality + "_" + game + "_background", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/background_" + game + ".jpg");
						REGISTRY_UTIL.setFile(FileRegistryType.TEXTURE, quality + "_" + game + "_background_pause", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/background_pause_" + game + ".jpg");
					}
				}
				
				methods = Util.getEnums(AudioQualityType);
				for each (quality in methods) {
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_music_main", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/music/" + quality + "/main.mp3");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_music_jazz", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/music/" + quality + "/jazz.mp3");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_clock", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/clock.wav");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_explosion", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/explosion.wav");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_pause", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/pause.wav");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_unpause", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/unpause.wav");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_select", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/select.wav");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_star_activation", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/star_activation.wav");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_star_appearance", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/star_appearance.wav");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_star_deactivation", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/star_deactivation.wav");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_sentry_shoot", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/horde/sentry_shoot.wav");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_fanfare", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/fanfare.wav");
					for each (game in games) {
						REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_music_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/music/" + quality + "/" + game + ".mp3");
						REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_stress_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/ambient/" + quality + "/" + game + "_stress.wav");
						REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_ball_hit_critical_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/" + game + "/ball_hit_critical.wav");
						REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_ball_hit_insecure_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/" + game + "/ball_hit_insecure.wav");
						REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_ball_hit_normal_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/" + game + "/ball_hit_normal.wav");
						REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_ball_miss_1_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/" + game + "/ball_miss_1.wav");
						REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_ball_miss_2_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/" + game + "/ball_miss_2.wav");
						REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, quality + "_game_over_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/" + game + "/game_over.wav");
					}
				}
				
				REGISTRY_UTIL.setFile(FileRegistryType.XML, "anim", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/anim.xml");
				for each (game in games) {
					REGISTRY_UTIL.setFile(FileRegistryType.XML, game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + game + ".xml");
				}
				
				nextState();
			}
		}
	}
}