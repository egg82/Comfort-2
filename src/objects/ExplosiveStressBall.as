package objects {
	import com.greensock.easing.Elastic;
	import com.greensock.TweenMax;
	import egg82.custom.CustomAtlasImage;
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
	import egg82.events.custom.CustomAtlasImageEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.prototype.interfaces.IPrototype;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.registry.interfaces.IRegistryUtil;
	import egg82.registry.RegistryUtil;
	import objects.base.BasePolyPhysicsObject;
	import objects.interfaces.ITriggerable;
	import physics.IPhysicsData;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class ExplosiveStressBall extends BasePolyPhysicsObject implements IPrototype, ITriggerable {
		//vars
		private var registryUtil:IRegistryUtil = ServiceLocator.getService("registryUtil") as IRegistryUtil;
		private var physicsRegistry:IRegistry = ServiceLocator.getService("physicsRegistry") as IRegistry;
		
		private var customAtlasImageObserver:Observer = new Observer();
		private var registryUtilObserver:Observer = new Observer();
		
		private var gameType:String;
		
		//constructor
		public function ExplosiveStressBall(gameType:String, triggerCallback:Function) {
			this.gameType = gameType;
			this.triggerCallback = triggerCallback;
			
			customAtlasImageObserver.add(onCustomAtlasImageObserverNotify);
			Observer.add(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			super(registryUtil.getFile(FileRegistryType.TEXTURE, gameType), registryUtil.getFile(FileRegistryType.XML, gameType), physicsRegistry.getRegister("explosion_" + registryUtil.getOption(OptionsRegistryType.PHYSICS, "shapeQuality")) as IPhysicsData, 1);
			body.allowRotation = true;
			body.allowMovement = true;
			body.scaleShapes(0.13, 0.13);
			
			body.applyAngularImpulse(1000);
		}
		
		//public
		override public function create():void {
			super.create();
			
			TweenMax.from(this, 0.75, {
				"scaleX": 0,
				"scaleY": 0,
				"ease": Elastic.easeOut
			});
		}
		
		public function clone():IPrototype {
			var c:ExplosiveStressBall = new ExplosiveStressBall(gameType, triggerCallback);
			c.create();
			return c;
		}
		
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
				setTextureFromName("ball_explosive");
			} else if (event == CustomAtlasImageEvent.ERROR) {
				
			}
			
			scaleX = scaleY = 0.6;
			
			alignPivot();
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