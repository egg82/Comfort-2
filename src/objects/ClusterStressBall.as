package objects {
	import egg82.enums.OptionsRegistryType;
	import egg82.patterns.Observer;
	import egg82.patterns.prototype.interfaces.IPrototype;
	import egg82.registry.RegistryUtil;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import objects.components.GraphicsComponent;
	import objects.components.PhysicsComponent;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class ClusterStressBall extends BaseObject implements IPrototype {
		//vars
		private var registryUtilObserver:Observer = new Observer();
		
		private var gameType:String;
		
		//constructor
		public function ClusterStressBall(gameType:String) {
			this.gameType = gameType;
			
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			physicsComponent = new PhysicsComponent(BodyType.DYNAMIC);
			graphicsComponent = new GraphicsComponent(gameType, "ball_explosive_cluster", 0.6);
			
			physicsComponent.setShapes([new Circle(4)]);
			
			physicsComponent.body.allowRotation = false;
			physicsComponent.body.allowMovement = true;
			physicsComponent.body.isBullet = false;
		}
		
		//public
		public function clone():IPrototype {
			var c:ClusterStressBall = new ClusterStressBall(gameType);
			c.create();
			return c;
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