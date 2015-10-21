package objects {
	import egg82.custom.CustomAtlasImage;
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
	import egg82.events.custom.CustomAtlasImageEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistryUtil;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import objects.base.BasePhysicsObject;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class Core extends BasePhysicsObject {
		//vars
		private var registryUtil:IRegistryUtil = ServiceLocator.getService("registryUtil") as IRegistryUtil;
		
		private var customAtlasImageObserver:Observer = new Observer();
		
		private var _health:Number = 0;
		
		//constructor
		public function Core(gameType:String, health:Number) {
			_health = health;
			
			customAtlasImageObserver.add(onCustomAtlasImageObserverNotify);
			Observer.add(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			var body:Body = new Body(BodyType.STATIC);
			body.shapes.add(new Circle(98));
			
			super(registryUtil.getFile(FileRegistryType.TEXTURE, registryUtil.getOption(OptionsRegistryType.VIDEO, "textureQuality") + "_" + gameType), registryUtil.getFile(FileRegistryType.XML, gameType), body, 0);
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
		
		//private
		private function onCustomAtlasImageObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== this) {
				return;
			}
			
			Observer.remove(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			if (event == CustomAtlasImageEvent.COMPLETE) {
				setTextureFromName("core");
			} else if (event == CustomAtlasImageEvent.ERROR) {
				
			}
			
			scaleX = scaleY = 0.6;
			
			alignPivot();
			pivotX += 2;
			pivotY += 2;
		}
	}
}