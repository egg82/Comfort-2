package objects {
	import egg82.custom.CustomAtlasImage;
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.events.custom.CustomAtlasImageEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.registry.interfaces.IRegistryUtil;
	import egg82.registry.RegistryUtil;
	import enums.CustomServiceType;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	import objects.base.BasePolyPhysicsObject;
	import physics.IPhysicsData;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class Sentry extends BasePolyPhysicsObject {
		//vars
		private var registryUtil:IRegistryUtil = ServiceLocator.getService(ServiceType.REGISTRY_UTIL) as IRegistryUtil;
		private var physicsRegistry:IRegistry = ServiceLocator.getService(CustomServiceType.PHYSICS_REGISTRY) as IRegistry;
		
		private var customAtlasImageObserver:Observer = new Observer();
		private var registryUtilObserver:Observer = new Observer();
		
		//constructor
		public function Sentry(gameType:String) {
			customAtlasImageObserver.add(onCustomAtlasImageObserverNotify);
			Observer.add(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			super(registryUtil.getFile(FileRegistryType.TEXTURE, gameType), registryUtil.getFile(FileRegistryType.XML, gameType), physicsRegistry.getRegister("sentry_" + registryUtil.getOption(OptionsRegistryType.PHYSICS, "shapeQuality")) as IPhysicsData, 0, BodyType.KINEMATIC);
			
			body.translateShapes(Vec2.weak(0, -120));
			body.allowRotation = true;
			body.allowMovement = false;
		}
		
		//public
		override public function destroy():void {
			Observer.remove(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			super.destroy();
		}
		
		//private
		private function onCustomAtlasImageObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== this) {
				return;
			}
			
			Observer.remove(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			if (event == CustomAtlasImageEvent.COMPLETE) {
				setTextureFromName("paddle");
			} else if (event == CustomAtlasImageEvent.ERROR) {
				
			}
			
			alignPivot();
			this.pivotY = 163;
		}
		
		private function onRegistryUtilObserverNotify(sender:Object, event:String, data:Object):void {
			if (data.registry == "optionsRegistry") {
				checkOptions(data.type as String, data.name as String, data.value as Object);
			}
		}
		private function checkOptions(type:String, name:String, value:Object):void {
			if (type == OptionsRegistryType.PHYSICS && name == "shapeQuality") {
				updateBody(physicsRegistry.getRegister("sentry_" + (value as String)) as IPhysicsData);
			}
		}
	}
}