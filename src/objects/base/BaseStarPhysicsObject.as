package objects.base {
	import com.greensock.easing.Elastic;
	import com.greensock.TweenMax;
	import egg82.custom.CustomAtlasImage;
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
	import egg82.events.custom.CustomAtlasImageEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.registry.interfaces.IRegistryUtil;
	import physics.IPhysicsData;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class BaseStarPhysicsObject extends BasePolyPhysicsObject {
		//vars
		private var registryUtil:IRegistryUtil = ServiceLocator.getService("registryUtil") as IRegistryUtil;
		private var physicsRegistry:IRegistry = ServiceLocator.getService("physicsRegistry") as IRegistry;
		
		private var customAtlasImageObserver:Observer = new Observer();
		
		private var starType:String;
		
		//constructor
		public function BaseStarPhysicsObject(gameType:String, starType:String, damage:Number) {
			customAtlasImageObserver.add(onCustomAtlasImageObserverNotify);
			Observer.add(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			this.starType = starType;
			
			super(registryUtil.getFile(FileRegistryType.TEXTURE, gameType), registryUtil.getFile(FileRegistryType.XML, gameType), physicsRegistry.getRegister("star_" + registryUtil.getOption(OptionsRegistryType.PHYSICS, "shapeQuality")) as IPhysicsData, damage);
			body.allowRotation = true;
			body.allowMovement = true;
			body.scaleShapes(0.6, 0.6);
			
			body.applyAngularImpulse(500);
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
		
		//private
		private function onCustomAtlasImageObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== this) {
				return;
			}
			
			Observer.remove(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			if (event == CustomAtlasImageEvent.COMPLETE) {
				setTextureFromName("star_" + starType);
			} else if (event == CustomAtlasImageEvent.ERROR) {
				
			}
			
			scaleX = scaleY = 0.6;
			
			alignPivot();
			pivotY += 3;
		}
	}
}