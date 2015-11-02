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
	
	public class AnimatedGraphicsComponent extends BaseGraphicsComponent {
		//vars
		private var registryUtil:IRegistryUtil = ServiceLocator.getService(ServiceType.REGISTRY_UTIL) as IRegistryUtil;
		
		private var textureName:String;
		private var _frameNum:uint = 1;
		
		//constructor
		public function AnimatedGraphicsComponent(textureName:String, frameNum:uint = 1, origScale:Number = 1, adjustX:Number = 0, adjustY:Number = 0, adjustRotation:Number = 0) {
			this.textureName = textureName;
			_frameNum = frameNum;
			
			super(registryUtil.getFile(FileRegistryType.TEXTURE, registryUtil.getOption(OptionsRegistryType.VIDEO, "textureQuality") + "_anim"), registryUtil.getFile(FileRegistryType.XML, "anim"), textureName + frameNum, origScale, adjustX, adjustY, adjustRotation);
		}
		
		//public
		public function get frameNum():uint {
			return _frameNum;
		}
		public function set frameNum(val:uint):void {
			if (isNaN(val)) {
				return;
			}
			
			_frameNum = val;
			super.setTextureName((_frameNum) ? textureName + _frameNum : "null");
		}
		
		override public function setTextureName(textureName:String):void {
			this.textureName = textureName;
			super.setTextureName((_frameNum) ? textureName + _frameNum : "null");
		}
		
		//private
		
	}
}