package objects {
	import com.greensock.easing.Elastic;
	import com.greensock.TweenMax;
	import egg82.custom.CustomAtlasImage;
	import egg82.engines.interfaces.IAudioEngine;
	import egg82.engines.interfaces.IInputEngine;
	import egg82.enums.ServiceType;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import events.BaseObjectEvent;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import objects.graphics.GraphicsComponent;
	import objects.physics.PhysicsComponent;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class BaseObject {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		protected var physicsComponent:PhysicsComponent;
		protected var graphicsComponent:GraphicsComponent;
		
		protected var inputEngine:IInputEngine = ServiceLocator.getService(ServiceType.INPUT_ENGINE) as IInputEngine;
		protected var audioEngine:IAudioEngine = ServiceLocator.getService(ServiceType.AUDIO_ENGINE) as IAudioEngine;
		
		private var _scale:Number = 1;
		
		//constructor
		public function BaseObject() {
			
		}
		
		//public
		public function get body():Body {
			return physicsComponent.body;
		}
		public function get graphics():CustomAtlasImage {
			return graphicsComponent as CustomAtlasImage;
		}
		
		public function create():void {
			if (physicsComponent) {
				physicsComponent.body.userData.parent = this;
				physicsComponent.create();
			}
			if (graphicsComponent) {
				graphicsComponent.create();
			}
			
			dispatch(BaseObjectEvent.CREATE);
		}
		
		public function draw():void {
			if (graphicsComponent && physicsComponent) {
				graphicsComponent.x = physicsComponent.body.worldCOM.x - 168;
				graphicsComponent.y = physicsComponent.body.worldCOM.y - 168;
				graphicsComponent.rotation = physicsComponent.body.rotation;
			}
		}
		
		public function destroy():void {
			if (physicsComponent) {
				physicsComponent.body.rotation = 0;
				physicsComponent.body.angularVel = 0;
				physicsComponent.body.velocity = Vec2.weak(0, 0);
				physicsComponent.destroy();
			}
			if (graphicsComponent) {
				graphicsComponent.destroy();
			}
			
			scale = 1;
			
			dispatch(BaseObjectEvent.DESTROY);
		}
		
		public function get scale():Number {
			return _scale;
		}
		public function set scale(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_scale = val;
			if (graphicsComponent) {
				graphicsComponent.scale = _scale;
			}
		}
		
		public function tweenScale(newScale:Number, duration:Number = 0.75):void {
			TweenMax.to(this, duration, {
				"scale": newScale,
				"ease": Elastic.easeOut,
				"onComplete": dispatch,
				"onCompleteParams": [BaseObjectEvent.TWEEN_FINISHED]
			});
		}
		
		//private
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}