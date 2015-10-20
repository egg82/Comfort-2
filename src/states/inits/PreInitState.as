package states.inits {
	import com.newgrounds.API;
	import egg82.base.BasePreInitState;
	import egg82.engines.interfaces.IStateEngine;
	import egg82.engines.nulls.NullModEngine;
	import egg82.enums.FileRegistryType;
	import egg82.enums.MouseCodes;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.enums.XboxButtonCodes;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.registry.Registry;
	import egg82.utils.MathUtil;
	import egg82.utils.NetUtil;
	import egg82.utils.Util;
	import enums.AudioQualityType;
	import enums.CustomOptionsRegistryType;
	import enums.CustomServiceType;
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
		
		//constructor
		public function PreInitState() {
			
		}
		
		//public
		override public function create(...args):void {
			super.create();
			
			//INIT_REGISTRY.setRegister("debug", false);
			/*INIT_REGISTRY.setRegister("memoryHandicap", null);
			(INIT_REGISTRY.getRegister("cpuHandicap") as Timer).stop();*/
			
			NetUtil.loadExactPolicyFile("https://egg82.ninja/crossdomain.xml");
			API.debugMode = (INIT_REGISTRY.getRegister("debug") as Boolean) ? API.DEBUG_MODE_LOGGED_OUT : API.RELEASE_MODE;
			API.connect(Starling.all[0].nativeOverlay, "36550:7oMQaUng", "6eJ8M5kiQGj9mZIDIXs2C1i3ouERVw23");
			
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
			
			REGISTRY_UTIL.setOption(OptionsRegistryType.NETWORK, "fileHosts", ["https://egg82.ninja/hosted/Comfort%202"]);
			REGISTRY_UTIL.setOption(OptionsRegistryType.PHYSICS, "shapeQuality", ShapeQualityType.LOW);
			REGISTRY_UTIL.setOption(OptionsRegistryType.VIDEO, "textureQuality", TextureQualityType.ULTRA);
			REGISTRY_UTIL.setOption(OptionsRegistryType.AUDIO, "musicQuality", AudioQualityType.ULTRA);
			REGISTRY_UTIL.setOption(OptionsRegistryType.AUDIO, "ambientQuality", AudioQualityType.ULTRA);
			REGISTRY_UTIL.setOption(OptionsRegistryType.AUDIO, "sfxQuality", AudioQualityType.ULTRA);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.GAMEPLAY, "autoFire", false);
			REGISTRY_UTIL.setOption(CustomOptionsRegistryType.GAMEPLAY, "difficulty", 1);
			REGISTRY_UTIL.setOption(OptionsRegistryType.KEYS, "fire", [MouseCodes.LEFT]);
			REGISTRY_UTIL.setOption(OptionsRegistryType.CONTROLLER, "fire", [XboxButtonCodes.A]);
			
			var fileHosts:Array = REGISTRY_UTIL.getOption(OptionsRegistryType.NETWORK, "fileHosts");
			var length:uint = fileHosts.length - 1;
			
			//TODO: Check fileHosts for hosts that are down and remove them from the array - except the first one
			
			var methods:Array;
			var quality:String;
			
			var games:Array = Util.getEnums(GameType);
			var game:String;
			
			//TODO Fix overwriting of quality
			methods = Util.getEnums(TextureQualityType);
			methods = ["ultra"];
			for each (quality in methods) {
				for each (game in games) {
					REGISTRY_UTIL.setFile(FileRegistryType.TEXTURE, game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/" + game + ".png");
					REGISTRY_UTIL.setFile(FileRegistryType.TEXTURE, game + "_background", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/background_" + game + ".jpg");
				}
			}
			methods = Util.getEnums(AudioQualityType);
			methods = ["ultra"];
			for each (quality in methods) {
				REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "music_main", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/music/" + quality + "/main.mp3");
				REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "clock", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/clock.wav");
				REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "explosion", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/explosion.wav");
				REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "pause", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/pause.wav");
				REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "unpause", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/unpause.wav");
				REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "select", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/select.wav");
				REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "star_activation", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/star_activation.wav");
				REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "star_appearance", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/star_appearance.wav");
				REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "star_deactivation", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/star_deactivation.wav");
				REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "sentry_shoot", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/horde/sentry_shoot.wav");
				for each (game in games) {
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "music_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/music/" + quality + "/" + game + ".mp3");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "stress_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/ambient/" + quality + "/" + game + "_stress.wav");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "ball_hit_critical_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/" + game + "/ball_hit_critical.wav");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "ball_hit_insecure_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/" + game + "/ball_hit_insecure.wav");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "ball_hit_normal_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/" + game + "/ball_hit_normal.wav");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "ball_miss_1_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/" + game + "/ball_miss_1.wav");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "ball_miss_2_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/" + game + "/ball_miss_2.wav");
					REGISTRY_UTIL.setFile(FileRegistryType.AUDIO, "game_over_" + game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/sfx/" + quality + "/" + game + "/game_over.wav");
				}
			}
			for each (game in games) {
				REGISTRY_UTIL.setFile(FileRegistryType.XML, game, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + game + ".xml");
			}
			
			REGISTRY_UTIL.setFont("note", NOTE);
			REGISTRY_UTIL.setFont("speech", SPEECH);
			
			trace("preInit");
			
			nextState();
		}
		
		//private
		
	}
}