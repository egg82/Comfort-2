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
	import starling.filters.ColorMatrixFilter;
	
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
		private var _origScale:Number = 1;
		private var _scale:Number = 1;
		private var _adjustX:Number = 0;
		private var _adjustY:Number = 0;
		
		private var brightnessFilter:ColorMatrixFilter = new ColorMatrixFilter();
		private var _brightness:Number = 0;
		
		//constructor
		public function GraphicsComponent(gameType:String, textureName:String, origScale:Number = 1, adjustX:Number = 0, adjustY:Number = 0) {
			this.gameType = gameType;
			this.textureName = textureName;
			_origScale = origScale;
			_adjustX = adjustX;
			_adjustY = adjustY;
			
			customAtlasImageObserver.add(onCustomAtlasImageObserverNotify);
			Observer.add(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			super(registryUtil.getFile(FileRegistryType.TEXTURE, registryUtil.getOption(OptionsRegistryType.VIDEO, "textureQuality") + "_" + gameType), registryUtil.getFile(FileRegistryType.XML, gameType));
		}
		
		//public
		override public function create():void {
			brightnessFilter.adjustBrightness(_brightness);
			filter = brightnessFilter;
			
			super.create();
		}
		override public function destroy():void {
			
		}
		
		public function get origScale():Number {
			return _origScale;
		}
		public function set origScale(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_origScale = val;
			realign();
		}
		
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
		
		public function get brightness():Number {
			return _brightness;
		}
		public function set brightness(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_brightness = val;
			brightnessFilter.reset();
			brightnessFilter.adjustBrightness(_brightness);
			filter = brightnessFilter;
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
		
		public function get adjustX():Number {
			return _adjustX;
		}
		public function set adjustX(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_adjustX = val;
		}
		
		public function get adjustY():Number {
			return _adjustY;
		}
		public function set adjustY(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_adjustY = val;
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
		
		public function realign():void {
			alignPivot();
			scaleX = scaleY = _scale * _origScale;
			pivotX += _adjustX;
			pivotY += _adjustY;
		}
	}
}