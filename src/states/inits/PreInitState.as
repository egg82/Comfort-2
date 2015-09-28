package states.inits {
	import egg82.base.BasePreInitState;
	import egg82.engines.interfaces.IStateEngine;
	import egg82.engines.nulls.NullModEngine;
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.registry.Registry;
	import egg82.utils.NetUtil;
	import enums.GameType;
	import enums.ShapeQualityType;
	import physics.high.StarHighData;
	import physics.low.StarLowData;
	import physics.medium.StarMediumData;
	import physics.ultra.StarUltraData;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class PreInitState extends BasePreInitState {
		//vars
		private var physicsRegistry:IRegistry;
		
		private var stateEngine:IStateEngine = ServiceLocator.getService("stateEngine") as IStateEngine;
		
		//constructor
		public function PreInitState() {
			
		}
		
		//public
		override public function create():void {
			super.create();
			
			//initRegistry.setRegister("debug", false);
			
			NetUtil.loadPolicyFile("https://egg82.ninja", 443);
			
			stateEngine.skipMultiplePhysicsUpdate = true;
			
			ServiceLocator.provideService("modEngine", NullModEngine);
			ServiceLocator.provideService("physicsRegistry", Registry, false);
			
			physicsRegistry = ServiceLocator.getService("physicsRegistry") as IRegistry;
			
			physicsRegistry.setRegister("star_" + ShapeQualityType.ULTRA, new StarUltraData());
			physicsRegistry.setRegister("star_" + ShapeQualityType.HIGH, new StarHighData());
			physicsRegistry.setRegister("star_" + ShapeQualityType.MEDIUM, new StarMediumData());
			physicsRegistry.setRegister("star_" + ShapeQualityType.LOW, new StarLowData());
			
			registryUtil.addFile(FileRegistryType.TEXTURE, GameType.HORDE, "https://egg82.ninja/hosted/Comfort%202/texture/horde.png");
			registryUtil.addFile(FileRegistryType.XML, GameType.HORDE, "https://egg82.ninja/hosted/Comfort%202/texture/horde.xml");
			
			registryUtil.addOption(OptionsRegistryType.PHYSICS, "shapeQuality", ShapeQualityType.ULTRA);
			
			//registryUtil.addFile(FileRegistryType.TEXTURE, "", "");
			//registryUtil.addOption(OptionsRegistryType.AUDIO, "", "");
			
			trace("preInit");
			
			nextState();
		}
		
		//private
		
	}
}