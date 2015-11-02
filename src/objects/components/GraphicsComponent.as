package objects.components {
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistryUtil;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class GraphicsComponent extends BaseGraphicsComponent {
		//vars
		private var registryUtil:IRegistryUtil = ServiceLocator.getService(ServiceType.REGISTRY_UTIL) as IRegistryUtil;
		
		//constructor
		public function GraphicsComponent(gameType:String, textureName:String, origScale:Number = 1, adjustX:Number = 0, adjustY:Number = 0, adjustRotation:Number = 0) {
			super(registryUtil.getFile(FileRegistryType.TEXTURE, registryUtil.getOption(OptionsRegistryType.VIDEO, "textureQuality") + "_" + gameType), registryUtil.getFile(FileRegistryType.XML, gameType), textureName, origScale, adjustX, adjustY, adjustRotation);
		}
		
		//public
		
		//private
		
	}
}