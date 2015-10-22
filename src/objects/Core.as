package objects {
	import egg82.enums.OptionsRegistryType;
	import egg82.patterns.Observer;
	import egg82.registry.RegistryUtil;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import objects.graphics.GraphicsComponent;
	import objects.physics.PhysicsComponent;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class Core extends BaseObject {
		//vars
		private var registryUtilObserver:Observer = new Observer();
		
		private var _health:Number = 0;
		
		//constructor
		public function Core(gameType:String, health:Number) {
			_health = health;
			
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			physicsComponent = new PhysicsComponent(BodyType.STATIC);
			graphicsComponent = new GraphicsComponent(gameType, "core", 0.6, 2, 2);
			
			physicsComponent.setShapes([new Circle(98)]);
			
			physicsComponent.body.allowRotation = false;
			physicsComponent.body.allowMovement = false;
			physicsComponent.body.isBullet = false;
		}
		
		//public
		public function get health():Number {
			return _health;
		}
		public function set health(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_health = val;
		}
		
		override public function destroy():void {
			Observer.remove(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			super.destroy();
		}
		
		//private
		private function onRegistryUtilObserverNotify(sender:Object, event:String, data:Object):void {
			if (data.registry == "optionsRegistry") {
				checkOptions(data.type as String, data.name as String, data.value as Object);
			}
		}
		private function checkOptions(type:String, name:String, value:Object):void {
			if (type == OptionsRegistryType.VIDEO && name == "textureQuality") {
				graphicsComponent.resetTexture();
			}
		}
	}
}