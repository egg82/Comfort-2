package objects.components {
	import egg82.custom.CustomAtlasImage;
	import egg82.events.custom.CustomAtlasImageEvent;
	import egg82.patterns.Observer;
	import objects.interfaces.IGraphicsComponent;
	import starling.filters.ColorMatrixFilter;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class BaseGraphicsComponent extends CustomAtlasImage implements IGraphicsComponent {
		//vars
		private var customAtlasImageObserver:Observer = new Observer();
		
		private var textureUrl:String;
		private var xmlUrl:String;
		private var textureName:String;
		private var _origScale:Number = 1;
		private var _scale:Number = 1;
		private var _adjustX:Number = 0;
		private var _adjustY:Number = 0
		private var _adjustRotation:Number = 0;
		
		private var colorFilter:ColorMatrixFilter = new ColorMatrixFilter();
		private var _brightness:Number = 0;
		private var _contrast:Number = 0;
		private var _saturation:Number = 0;
		
		//constructor
		public function BaseGraphicsComponent(textureUrl:String, xmlUrl:String, textureName:String, origScale:Number = 1, adjustX:Number = 0, adjustY:Number = 0, adjustRotation:Number = 0) {
			this.textureUrl = textureUrl;
			this.xmlUrl = xmlUrl;
			this.textureName = textureName;
			_origScale = origScale;
			_adjustX = adjustX;
			_adjustY = adjustY;
			_adjustRotation = adjustRotation;
			
			customAtlasImageObserver.add(onCustomAtlasImageObserverNotify);
			Observer.add(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			super(textureUrl, xmlUrl);
		}
		
		//public
		override public function create():void {
			resetFilter();
			super.create();
			realign();
		}
		override public function destroy():void {
		
		}
		
		public function update(deltaTime:Number):void {
			
		}
		public function draw():void {
			
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
			resetFilter();
		}
		
		public function get contrast():Number {
			return _contrast;
		}
		public function set contrast(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_contrast = val;
			resetFilter();
		}
		
		public function get saturation():Number {
			return _saturation;
		}
		public function set saturation(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_saturation = val;
			resetFilter();
		}
		
		public function setTextureName(textureName:String):void {
			this.textureName = textureName;
			
			setTextureFromName(textureName);
			realign();
		}
		public function resetTexture():void {
			Observer.add(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			load(textureUrl, xmlUrl);
		}
		
		public function get adjustX():Number {
			return _adjustX;
		}
		public function set adjustX(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_adjustX = val;
			realign();
		}
		
		public function get adjustY():Number {
			return _adjustY;
		}
		public function set adjustY(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_adjustY = val;
			realign();
		}
		
		public function get adjustRotation():Number {
			return _adjustRotation;
		}
		public function set adjustRotation(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_adjustRotation = val;
			realign();
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
		
		protected function realign():void {
			alignPivot();
			scaleX = scaleY = _scale * _origScale;
			pivotX += _adjustX;
			pivotY += _adjustY;
			rotation = _adjustRotation;
		}
		protected function resetFilter():void {
			colorFilter.reset();
			colorFilter.adjustBrightness(_brightness);
			colorFilter.adjustContrast(_contrast);
			colorFilter.adjustSaturation(_saturation);
			filter = colorFilter;
		}
	}
}