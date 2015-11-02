package objects {
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistryUtil;
	import egg82.registry.RegistryUtil;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import objects.components.AnimatedGraphicsComponent;
	import objects.components.BlankGraphicsComponent;
	import objects.components.custom.CoreGraphicsComponent;
	import objects.components.GraphicsComponent;
	import objects.components.MaskedGraphicsComponent;
	import objects.components.PhysicsComponent;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class Core extends BaseObject {
		//vars
		private var registryUtil:IRegistryUtil = ServiceLocator.getService(ServiceType.REGISTRY_UTIL) as IRegistryUtil;
		
		private var registryUtilObserver:Observer = new Observer();
		
		private var _health:Number = 0;
		
		//constructor
		public function Core(gameType:String, health:Number) {
			_health = health;
			
			physicsComponent = new PhysicsComponent(BodyType.STATIC);
			graphicsComponent = new CoreGraphicsComponent(gameType, 98);
			
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
		
		override public function create():void {
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			super.create();
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
				if (graphicsComponent["resetTexture"] && graphicsComponent["resetTexture"] is Function) {
					(graphicsComponent["resetTexture"] as Function).call();
				}
			}
		}
	}
}