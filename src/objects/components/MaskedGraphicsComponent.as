package objects.components {
	import objects.interfaces.IGraphicsComponent;
	import starling.display.Canvas;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class MaskedGraphicsComponent extends DisplayObjectContainer implements IGraphicsComponent {
		//vars
		private var _origScale:Number = 1;
		private var _scale:Number = 1;
		private var _adjustX:Number = 0;
		private var _adjustY:Number = 0
		private var _adjustRotation:Number = 0;
		
		private var _brightness:Number = 0;
		
		private var _canvas:Canvas = new Canvas();
		
		//constructor
		public function MaskedGraphicsComponent(origScale:Number = 1, adjustX:Number = 0, adjustY:Number = 0, adjustRotation:Number = 0) {
			_origScale = origScale;
			_adjustX = adjustX;
			_adjustY = adjustY;
			_adjustRotation = adjustRotation;
		}
		
		//public
		public function get canvas():Canvas {
			return _canvas;
		}
		
		public function create():void {
			mask = _canvas;
			
			for (var i:int = numChildren - 1; i >= 0; i--) {
				var child:DisplayObject = getChildAt(i);
				
				if (!child) {
					continue;
				}
				
				if ("create" in child && child["create"] is Function) {
					(child["create"] as Function).call();
				}
				child.x = child.width / 2;
				child.y = child.height / 2;
			}
			
			realign();
		}
		public function destroy():void {
			for (var i:int = numChildren - 1; i >= 0; i--) {
				var child:DisplayObject = getChildAt(i);
				
				if (!child) {
					continue;
				}
				
				if ("destroy" in child && child["destroy"] is Function) {
					(child["destroy"] as Function).call();
				}
			}
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
			for (var i:int = numChildren - 1; i >= 0; i--) {
				var child:DisplayObject = getChildAt(i);
				
				if (!child) {
					continue;
				}
				
				if ("brightness" in child && child["brightness"] is Function) {
					(child["brightness"] as Function).apply(null, val);
				}
			}
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
		
		public function realign():void {
			_canvas.alignPivot();
			_canvas.scaleX = _canvas.scaleY = _scale * _origScale;
			_canvas.pivotX += _adjustX;
			_canvas.pivotY += _adjustY;
			_canvas.rotation = _adjustRotation;
			
			alignPivot();
			scaleX = scaleY = _scale * _origScale;
			pivotX += _adjustX;
			pivotY += _adjustY;
			rotation = _adjustRotation;
		}
		
		//private
		
	}
}