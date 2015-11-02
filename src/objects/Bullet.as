package objects {
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.patterns.Observer;
	import egg82.patterns.prototype.interfaces.IPrototype;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.registry.interfaces.IRegistryUtil;
	import egg82.registry.RegistryUtil;
	import egg82.utils.Util;
	import enums.CustomServiceType;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	import objects.components.GraphicsComponent;
	import objects.interfaces.ITriggerable;
	import objects.components.PhysicsComponent;
	import physics.IPhysicsData;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class Bullet extends BaseObject implements IPrototype {
		//vars
		private var physicsRegistry:IRegistry = ServiceLocator.getService(CustomServiceType.PHYSICS_REGISTRY) as IRegistry;
		private var registryUtil:IRegistryUtil = ServiceLocator.getService(ServiceType.REGISTRY_UTIL) as IRegistryUtil;
		
		private var registryUtilObserver:Observer = new Observer();
		
		private var gameType:String;
		
		//constructor
		public function Bullet(gameType:String) {
			this.gameType = gameType;
			
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			physicsComponent = new PhysicsComponent(BodyType.DYNAMIC, 0.6);
			graphicsComponent = new GraphicsComponent(gameType, "bullet", 0.6);
			
			physicsComponent.setShapes(Util.toArray((physicsRegistry.getRegister("bullet_" + registryUtil.getOption(OptionsRegistryType.PHYSICS, "shapeQuality")) as IPhysicsData).getPolygons()));
			
			physicsComponent.body.allowRotation = true;
			physicsComponent.body.allowMovement = true;
			physicsComponent.body.isBullet = true;
			
			setInitialPosition();
		}
		
		//public
		public function resetPosition():void {
			physicsComponent.body.position = physicsComponent.body.worldCOM;
			physicsComponent.body.translateShapes(Vec2.weak(0, 168));
		}
		
		public function clone():IPrototype {
			var c:Bullet = new Bullet(gameType);
			c.create();
			return c;
		}
		
		override public function destroy():void {
			Observer.remove(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			setInitialPosition();
			
			super.destroy();
		}
		
		//private
		private function onRegistryUtilObserverNotify(sender:Object, event:String, data:Object):void {
			if (data.registry == "optionsRegistry") {
				checkOptions(data.type as String, data.name as String, data.value as Object);
			}
		}
		private function checkOptions(type:String, name:String, value:Object):void {
			if (type == OptionsRegistryType.PHYSICS && name == "shapeQuality") {
				physicsComponent.setShapes(Util.toArray((physicsRegistry.getRegister("bullet_" + (value as String)) as IPhysicsData).getPolygons()));
				physicsComponent.body.translateShapes(Vec2.weak(0, -168));
			} else if (type == OptionsRegistryType.VIDEO && name == "textureQuality") {
				if (graphicsComponent["resetTexture"] && graphicsComponent["resetTexture"] is Function) {
					(graphicsComponent["resetTexture"] as Function).call();
				}
			}
		}
		
		private function setInitialPosition():void {
			physicsComponent.body.translateShapes(Vec2.weak(0, -168));
		}
	}
}