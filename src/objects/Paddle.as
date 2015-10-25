package objects {
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.registry.interfaces.IRegistryUtil;
	import egg82.registry.RegistryUtil;
	import egg82.utils.Util;
	import enums.CustomServiceType;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	import objects.graphics.GraphicsComponent;
	import objects.physics.PhysicsComponent;
	import physics.IPhysicsData;
	/**
	 * ...
	 * @author Alex
	 */
	
	public class Paddle extends BaseObject {
		//vars
		private var physicsRegistry:IRegistry = ServiceLocator.getService(CustomServiceType.PHYSICS_REGISTRY) as IRegistry;
		private var registryUtil:IRegistryUtil = ServiceLocator.getService(ServiceType.REGISTRY_UTIL) as IRegistryUtil;
		
		private var registryUtilObserver:Observer = new Observer();
		
		private var gameType:String;
		private var reverse:Boolean;
		
		//constructor
		public function Paddle(gameType:String, reverse:Boolean) {
			this.gameType = gameType;
			
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			physicsComponent = new PhysicsComponent(BodyType.KINEMATIC, 0.6);
			graphicsComponent = new GraphicsComponent(gameType, "paddle" + ((reverse) ? "2" : ""), 0.6);
			
			physicsComponent.setShapes(Util.toArray((physicsRegistry.getRegister("paddle_" + registryUtil.getOption(OptionsRegistryType.PHYSICS, "shapeQuality")) as IPhysicsData).getPolygons()));
			
			physicsComponent.body.allowRotation = true;
			physicsComponent.body.allowMovement = false;
			physicsComponent.body.isBullet = false;
			
			physicsComponent.body.translateShapes(Vec2.weak(0, -120));
			if (reverse) {
				body.rotation = Math.PI;
			}
		}
		
		//public
		public function tweenResize(size:Number):void {
			
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
			if (type == OptionsRegistryType.PHYSICS && name == "shapeQuality") {
				physicsComponent.setShapes(Util.toArray((physicsRegistry.getRegister("paddle_" + (value as String)) as IPhysicsData).getPolygons()));
			} else if (type == OptionsRegistryType.VIDEO && name == "textureQuality") {
				graphicsComponent.resetTexture();
			}
		}
	}
}