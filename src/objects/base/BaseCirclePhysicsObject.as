package objects.base {
	import com.greensock.easing.Elastic;
	import com.greensock.TweenMax;
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
		public function BaseCirclePhysicsObject(gameType:String, imageName:String, radius:Number, damage:Number) {
			customAtlasImageObserver.add(onCustomAtlasImageObserverNotify);
			Observer.add(CustomAtlasImage.OBSERVERS, customAtlasImageObserver);
			
			this.imageName = imageName;
			
			var body:Body = new Body(BodyType.DYNAMIC);
			body.shapes.add(new Circle(radius));
			body.allowMovement = true;
			body.allowRotation = false;
			
			super(registryUtil.getFile(FileRegistryType.TEXTURE, registryUtil.getOption(OptionsRegistryType.VIDEO, "textureQuality") + "_" + gameType), registryUtil.getFile(FileRegistryType.XML, gameType), body, damage);
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
				setTextureFromName(imageName);
			} else if (event == CustomAtlasImageEvent.ERROR) {
				
			}
			
			scaleX = scaleY = 0.6;
			
			alignPivot();
		}
	}
}