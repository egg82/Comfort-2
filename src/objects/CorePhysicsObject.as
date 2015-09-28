package objects {
	import egg82.custom.CustomAtlasImage;
	import egg82.enums.FileRegistryType;
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
	
	public class CorePhysicsObject extends BasePhysicsObject {
		//vars
		private var registryUtil:IRegistryUtil = ServiceLocator.getService("registryUtil") as IRegistryUtil;
		
		private var customAtlasImageObserver:Observer = new Observer();
		
		//constructor
		public function CorePhysicsObject(gameType:String) {
			customAtlasImageObserver.add(onCustomAtlasImageObserverNotify);
			Observer.add(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			var body:Body = new Body(BodyType.STATIC);
			body.shapes.add(new Circle(166));
			
			super(registryUtil.getFile(FileRegistryType.TEXTURE, gameType), registryUtil.getFile(FileRegistryType.XML, gameType), body);
		}
		
		//public
		
		//private
		private function onCustomAtlasImageObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== this) {
				return;
			}
			
			if (event == CustomAtlasImageEvent.COMPLETE) {
				setTextureFromName("core");
			} else if (event == CustomAtlasImageEvent.ERROR) {
				
			}
			
			alignPivot();
			pivotX += 1;
			pivotY += 1;
		}
	}
}