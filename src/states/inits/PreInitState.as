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
			
			//initRegistry.setRegister("debug", false);
			/*initRegistry.setRegister("memoryHandicap", null);
			(initRegistry.getRegister("cpuHandicap") as Timer).stop();*/
			
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
			
			REGISTRY_UTIL.addOption(OptionsRegistryType.NETWORK, "fileHosts", ["https://egg82.ninja/hosted/Comfort%202"]);
			REGISTRY_UTIL.addOption(OptionsRegistryType.PHYSICS, "shapeQuality", ShapeQualityType.ULTRA);
			REGISTRY_UTIL.addOption(OptionsRegistryType.VIDEO, "textureQuality", TextureQualityType.ULTRA);
			REGISTRY_UTIL.addOption(CustomOptionsRegistryType.GAMEPLAY, "autoFire", false);
			REGISTRY_UTIL.addOption(CustomOptionsRegistryType.GAMEPLAY, "difficulty", 1);
			REGISTRY_UTIL.addOption(OptionsRegistryType.KEYS, "fire", [MouseCodes.LEFT]);
			REGISTRY_UTIL.addOption(OptionsRegistryType.CONTROLLER, "fire", [XboxButtonCodes.A]);
			
			var fileHosts:Array = REGISTRY_UTIL.getOption(OptionsRegistryType.NETWORK, "fileHosts");
			var length:uint = fileHosts.length - 1;
			
			//TODO: Check fileHosts for hosts that are down and remove them from the array - except the first one
			
			var methods:Array = Util.getEnums(TextureQualityType);
			for each (var quality:String in methods) {
				REGISTRY_UTIL.addFile(FileRegistryType.TEXTURE, GameType.HORDE, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/horde.png");
				REGISTRY_UTIL.addFile(FileRegistryType.TEXTURE, GameType.HORDE + "_background", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/background_horde.jpg");
				REGISTRY_UTIL.addFile(FileRegistryType.TEXTURE, GameType.MASK, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/mask.png");
				REGISTRY_UTIL.addFile(FileRegistryType.TEXTURE, GameType.MASK + "_background", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/background_mask.jpg");
				REGISTRY_UTIL.addFile(FileRegistryType.TEXTURE, GameType.NEMESIS, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/nemesis.png");
				REGISTRY_UTIL.addFile(FileRegistryType.TEXTURE, GameType.NEMESIS + "_background", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/background_nemesis.jpg");
				REGISTRY_UTIL.addFile(FileRegistryType.TEXTURE, GameType.UNITY, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/unity.png");
				REGISTRY_UTIL.addFile(FileRegistryType.TEXTURE, GameType.UNITY + "_background", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + quality + "/background_unity.jpg");
			}
			REGISTRY_UTIL.addFile(FileRegistryType.XML, GameType.HORDE, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/horde.xml");
			REGISTRY_UTIL.addFile(FileRegistryType.XML, GameType.MASK, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/mask.xml");
			REGISTRY_UTIL.addFile(FileRegistryType.XML, GameType.NEMESIS, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/nemesis.xml");
			REGISTRY_UTIL.addFile(FileRegistryType.XML, GameType.UNITY, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/unity.xml");
			
			REGISTRY_UTIL.addFont("note", NOTE);
			REGISTRY_UTIL.addFont("speech", SPEECH);
			
			trace("preInit");
			
			nextState();
		}
		
		//private
		
	}
}