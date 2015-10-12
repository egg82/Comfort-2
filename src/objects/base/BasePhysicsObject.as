package objects.base {
	import com.greensock.easing.Elastic;
	import com.greensock.TweenMax;
	import egg82.custom.CustomAtlasImage;
	import egg82.engines.interfaces.IPhysicsEngine;
	import egg82.patterns.ServiceLocator;
	import egg82.utils.MathUtil;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Shape;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class BasePhysicsObject extends CustomAtlasImage {
		//vars
		private var _body:Body;
		private var zeroMat:Material = new Material(1, 0, 0, MathUtil.betterRoundedRandom(80, 100) / 100, 0);
		
		private var prevScaleX:Number = NaN;
		private var prevScaleY:Number = NaN;
		
		private var physicsEngine:IPhysicsEngine = ServiceLocator.getService("physicsEngine") as IPhysicsEngine;
		
		private var _damage:Number = 0;
		
		public var triggerCallback:Function = null;
		public var triggerCallbackParams:Array = null;
		
		//constructor
		public function BasePhysicsObject(atlasUrl:String, atlasXMLUrl:String, body:Body, damage:Number) {
			_damage = damage;
			
			super(atlasUrl, atlasXMLUrl);
			
			body.shapes.foreach(function(shape:Shape):void {
				shape.material = zeroMat;
			});
			
			var anchor:Vec2 = body.localCOM.copy(true);
			body.translateShapes(Vec2.weak(-anchor.x, -anchor.y));
			this.pivotX = anchor.x;
			this.pivotY = anchor.y;
			
			body.userData.parent = this;
			_body = body;
		}
		
		//public
		/*public function update(deltaTime:Number):void {
			if (_body.velocity.length < 200) {
				_body.velocity.length = 200;
			} else if (_body.velocity.length > 300) {
				_body.velocity.length = 300;
			}
		}*/
		
		public function get damage():Number {
			return _damage;
		}
		public function set damage(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_damage = val;
		}
		
		public function trigger(hitObj:BasePhysicsObject):void {
			triggerCallbackParams = [this, hitObj];
			
			if (triggerCallback != null) {
				triggerCallback.apply(null, triggerCallbackParams);
			}
		}
		
		public function draw():void {
			this.x = _body.position.x;
			this.y = _body.position.y;
			this.rotation = _body.rotation;
		}
		
		override public function destroy():void {
			removeFromParent();
			physicsEngine.removeBody(_body);
			if (!isNaN(prevScaleX)) {
				scaleX = prevScaleX;
			}
			if (!isNaN(prevScaleY)) {
				scaleY = prevScaleY;
			}
			_body.rotation = 0;
			_body.angularVel = 0;
			_body.velocity = Vec2.weak(0, 0);
			super.destroy();
		}
		
		public function get body():Body {
			return _body;
		}
		
		public function tweenRemove(optionalCallback:Function = null, optionalCallbackParams:Array = null):void {
			physicsEngine.removeBody(_body);
			
			prevScaleX = scaleX;
			prevScaleY = scaleY;
			
			TweenMax.to(this, 1, {
				"scaleX": 0,
				"scaleY": 0,
				"ease": Elastic.easeOut,
				"onComplete": onTweenComplete,
				"onCompleteParams": [optionalCallback, optionalCallbackParams]
			});
		}
		
		//private
		private function onTweenComplete(optionalCallback:Function, optionalCallbackParams:Array):void {
			destroy();
			
			if (optionalCallback != null) {
				if (optionalCallbackParams) {
					optionalCallback.apply(null, optionalCallbackParams);
				} else {
					optionalCallback.call();
				}
			}
		}
	}
}