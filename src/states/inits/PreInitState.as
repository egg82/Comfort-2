package states.inits {
	import egg82.base.BasePreInitState;
	import egg82.engines.interfaces.IStateEngine;
	import egg82.engines.nulls.NullModEngine;
	import egg82.enums.FileRegistryType;
	import egg82.enums.MouseCodes;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.XboxButtonCodes;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.registry.Registry;
	import egg82.utils.MathUtil;
	import egg82.utils.NetUtil;
	import enums.CustomOptionsRegistryType;
	import enums.GameType;
	import enums.ShapeQualityType;
	import enums.TextureQualityType;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import physics.high.BulletHighData;
	import physics.high.ExplosionHighData;
	import physics.high.SentryHighData;
	import physics.high.StarHighData;
	import physics.low.ExplosionLowData;
	import physics.low.SentryLowData;
	import physics.low.StarLowData;
	import physics.medium.ExplosionMediumData;
	import physics.medium.SentryMediumData;
	import physics.medium.StarMediumData;
	import physics.ultra.BulletUltraData;
	import physics.ultra.ExplosionUltraData;
	import physics.ultra.SentryUltraData;
	import physics.ultra.StarUltraData;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class PreInitState extends BasePreInitState {
		//vars
		private var physicsRegistry:IRegistry;
		
		private var stateEngine:IStateEngine = ServiceLocator.getService("stateEngine") as IStateEngine;
		private var waitTimer:Timer = new Timer(6000, 1);
		
		[Embed(source = "../../../res/font/note.ttf", fontName = "note", mimeType = "application/x-font", fontWeight = "normal", fontStyle = "normal", unicodeRange = "U+0020-U+007e", advancedAntiAliasing = "true", embedAsCFF = "false")]
		private static var NOTE:Class;
		[Embed(source = "../../../res/font/speech.ttf", fontName = "speech", mimeType = "application/x-font", fontWeight = "normal", fontStyle = "normal", unicodeRange = "U+0020-U+007e", advancedAntiAliasing = "true", embedAsCFF = "false")]
		private static var SPEECH:Class;
		
		//constructor
		public function PreInitState() {
			
		}
		
		//public
		override public function create():void {
			super.create();
			
			//initRegistry.setRegister("debug", false);
			/*initRegistry.setRegister("memoryHandicap", null);
			(initRegistry.getRegister("cpuHandicap") as Timer).stop();*/
			
			NetUtil.loadExactPolicyFile("https://egg82.ninja/crossdomain.xml");
			
			stateEngine.skipMultiplePhysicsUpdate = true;
			
			ServiceLocator.provideService("modEngine", NullModEngine);
			ServiceLocator.provideService("physicsRegistry", Registry, false);
			
			physicsRegistry = ServiceLocator.getService("physicsRegistry") as IRegistry;
			
			physicsRegistry.setRegister("star_" + ShapeQualityType.ULTRA, new StarUltraData());
			physicsRegistry.setRegister("star_" + ShapeQualityType.HIGH, new StarHighData());
			physicsRegistry.setRegister("star_" + ShapeQualityType.MEDIUM, new StarMediumData());
			physicsRegistry.setRegister("star_" + ShapeQualityType.LOW, new StarLowData());
			
			physicsRegistry.setRegister("explosion_" + ShapeQualityType.ULTRA, new ExplosionUltraData());
			physicsRegistry.setRegister("explosion_" + ShapeQualityType.HIGH, new ExplosionHighData());
			physicsRegistry.setRegister("explosion_" + ShapeQualityType.MEDIUM, new ExplosionMediumData());
			physicsRegistry.setRegister("explosion_" + ShapeQualityType.LOW, new ExplosionLowData());
			
			physicsRegistry.setRegister("sentry_" + ShapeQualityType.ULTRA, new SentryUltraData());
			physicsRegistry.setRegister("sentry_" + ShapeQualityType.HIGH, new SentryHighData());
			physicsRegistry.setRegister("sentry_" + ShapeQualityType.MEDIUM, new SentryMediumData());
			physicsRegistry.setRegister("sentry_" + ShapeQualityType.LOW, new SentryLowData());
			
			physicsRegistry.setRegister("bullet_" + ShapeQualityType.ULTRA, new BulletUltraData());
			physicsRegistry.setRegister("bullet_" + ShapeQualityType.HIGH, new BulletHighData());
			/*physicsRegistry.setRegister("bullet_" + ShapeQualityType.MEDIUM, new BulletMediumData());
			physicsRegistry.setRegister("bullet_" + ShapeQualityType.LOW, new BulletLowData());*/
			
			registryUtil.addOption(OptionsRegistryType.NETWORK, "fileHosts", ["https://egg82.ninja/hosted/Comfort%202"]);
			registryUtil.addOption(OptionsRegistryType.PHYSICS, "shapeQuality", ShapeQualityType.HIGH);
			registryUtil.addOption(OptionsRegistryType.VIDEO, "textureQuality", TextureQualityType.ULTRA);
			registryUtil.addOption(CustomOptionsRegistryType.GAMEPLAY, "autoFire", false);
			registryUtil.addOption(OptionsRegistryType.KEYS, "fire", [MouseCodes.LEFT]);
			registryUtil.addOption(OptionsRegistryType.CONTROLLER, "fire", [XboxButtonCodes.A]);
			
			var fileHosts:Array = registryUtil.getOption(OptionsRegistryType.NETWORK, "fileHosts");
			var length:uint = fileHosts.length - 1;
			
			//TODO: Check fileHosts for hosts that are down and remove them from the array - except the first one
			
			var textureQuality:String = registryUtil.getOption(OptionsRegistryType.VIDEO, "textureQuality") as String;
			registryUtil.addFile(FileRegistryType.TEXTURE, GameType.HORDE, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + textureQuality + "/horde.png");
			registryUtil.addFile(FileRegistryType.TEXTURE, GameType.HORDE + "_background", fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/" + textureQuality + "/background_horde.jpg");
			registryUtil.addFile(FileRegistryType.XML, GameType.HORDE, fileHosts[MathUtil.betterRoundedRandom(0, length)] + "/texture/horde.xml");
			
			registryUtil.addFont("note", NOTE);
			registryUtil.addFont("speech", SPEECH);
			
			//registryUtil.addFile(FileRegistryType.TEXTURE, "", "");
			//registryUtil.addOption(OptionsRegistryType.AUDIO, "", "");
			
			trace("preInit");
			
			//waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			//waitTimer.start();
			nextState();
		}
		
		//private
		private function onTimerComplete(e:TimerEvent):void {
			waitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			nextState();
		}
	}
}