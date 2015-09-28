package objects.base {
	import egg82.custom.CustomAtlasImage;
	import egg82.enums.FileRegistryType;
	import egg82.events.custom.CustomAtlasImageEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistryUtil;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class BaseCirclePhysicsObject extends BasePhysicsObject {
		//vars
		private var imageName:String;
		
		private var registryUtil:IRegistryUtil = ServiceLocator.getService("registryUtil") as IRegistryUtil;
		
		private var customAtlasImageObserver:Observer = new Observer();
		
		//constructor
		public function BaseCirclePhysicsObject(gameType:String, imageName:String, radius:Number) {
			customAtlasImageObserver.add(onCustomAtlasImageObserverNotify);
			Observer.add(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			this.imageName = imageName;
			
			var body:Body = new Body(BodyType.DYNAMIC);
			body.shapes.add(new Circle(radius));
			body.allowMovement = true;
			body.allowRotation = true;
			
			super(registryUtil.getFile(FileRegistryType.TEXTURE, gameType), registryUtil.getFile(FileRegistryType.XML, gameType), body);
		}
		
		//public
		
		//private
		private function onCustomAtlasImageObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== this) {
				return;
			}
			
			if (event == CustomAtlasImageEvent.COMPLETE) {
				setTextureFromName(imageName);
			} else if (event == CustomAtlasImageEvent.ERROR) {
				
			}
		}
	}
}