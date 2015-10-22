package objects.physics {
	import egg82.patterns.interfaces.IComponent;
	import egg82.utils.MathUtil;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Shape;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class PhysicsComponent implements IComponent {
		//vars
		private var zeroMat:Material = new Material(1, 0, 0, MathUtil.betterRoundedRandom(80, 100) / 100, 0);
		
		private var _body:Body;
		
		private var _origScale:Number = 1;
		private var _scale:Number = 1;
		
		//constructor
		public function PhysicsComponent(bodyType:BodyType, origScale:Number = 1) {
			_origScale = origScale;
			_body = new Body(bodyType);
		}
		
		//public
		public function get body():Body {
			return _body;
		}
		
		public function setShapes(shapes:Array):void {
			var newShapes:Array = getShapes(shapes);
			
			_body.shapes.clear();
			for (var i:uint = 0; i < newShapes.length; i++) {
				_body.shapes.add(newShapes[i]);
			}
			
			_body.scaleShapes(_origScale * _scale, _origScale * _scale);
			
			var anchor:Vec2 = _body.localCOM.copy(true);
			_body.translateShapes(Vec2.weak(-anchor.x, -anchor.y));
			
			_body.shapes.foreach(function(shape:Shape):void {
				shape.material = zeroMat;
			});
		}
		
		public function get origScale():Number {
			return _origScale;
		}
		public function set origScale(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_origScale = val;
			_body.scaleShapes(_scale * val, _scale * val);
		}
		
		public function get scale():Number {
			return _scale;
		}
		public function set scale(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			if (_body.type != BodyType.DYNAMIC) {
				return;
			}
			
			_scale = val;
			if (_origScale != 0 && val != 0) {
				_body.scaleShapes(_origScale * val, _origScale * val);
			} else {
				_body.scaleShapes(0.001, 0.001);
			}
		}
		
		//private
		private function getShapes(shapes:Array):Array {
			var retArr:Array = new Array();
			
			for each (var shape:* in shapes) {
				if (shape is Shape) {
					retArr.push(shape);
				}
			}
			
			return retArr;
		}
	}
}