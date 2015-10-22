package objects.graphics {
	import egg82.custom.CustomAtlasImage;
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.events.custom.CustomAtlasImageEvent;
	import egg82.patterns.interfaces.IComponent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistryUtil;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class GraphicsComponent extends CustomAtlasImage implements IComponent {
		//vars
		private var registryUtil:IRegistryUtil = ServiceLocator.getService(ServiceType.REGISTRY_UTIL) as IRegistryUtil;
		
		private var customAtlasImageObserver:Observer = new Observer();
		
		private var gameType:String;
		private var textureName:String;
		private var _scale:Number = 1;
		private var adjustX:Number = 0;
		private var adjustY:Number = 0;
		
		//constructor
		public function GraphicsComponent(gameType:String, textureName:String, scale:Number = 1, adjustX:Number = 0, adjustY:Number = 0) {
			this.gameType = gameType;
			this.textureName = textureName;
			_scale = scale;
			this.adjustX = adjustX;
			this.adjustY = adjustY;
			
			customAtlasImageObserver.add(onCustomAtlasImageObserverNotify);
			Observer.add(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			super(registryUtil.getFile(FileRegistryType.TEXTURE, registryUtil.getOption(OptionsRegistryType.VIDEO, "textureQuality") + "_" + gameType), registryUtil.getFile(FileRegistryType.XML, gameType));
		}
		
		//public
		public function get scale():Number {
			return _scale;
		}
		public function set scale(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_scale = val;
			realign();
		}
		
		public function setTextureName(textureName:String):void {
			this.textureName = textureName;
			
			setTextureFromName(textureName);
			realign();
		}
		public function resetTexture():void {
			Observer.add(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			load(registryUtil.getFile(FileRegistryType.TEXTURE, registryUtil.getOption(OptionsRegistryType.VIDEO, "textureQuality") + "_" + gameType), registryUtil.getFile(FileRegistryType.XML, gameType));
		}
		
		//private
		private function onCustomAtlasImageObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== this) {
				return;
			}
			
			Observer.remove(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			if (event == CustomAtlasImageEvent.COMPLETE) {
				setTextureFromName(textureName);
			} else if (event == CustomAtlasImageEvent.ERROR) {
				
			}
			
			realign();
		}
		
		private function realign():void {
			scaleX = scaleY = _scale;
			alignPivot();
			pivotX = adjustX;
			pivotY = adjustY;
		}
	}
}