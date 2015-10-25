package states.components {
	import egg82.engines.PhysicsEngine;
	import egg82.events.engines.PhysicsEngineEvent;
	import egg82.patterns.interfaces.IComponent;
	import egg82.patterns.Observer;
	import nape.phys.Body;
	import objects.BaseObject;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class CollisionComponent implements IComponent {
		//vars
		private var collideCallback:Function = null;
		
		private var physicsEngineObserver:Observer = new Observer();
		
		//constructor
		public function CollisionComponent(collideCallback:Function) {
			this.collideCallback = collideCallback;
		}
		
		//public
		public function create():void {
			physicsEngineObserver.add(onPhysicsEngineObserverNotify);
			Observer.add(PhysicsEngine.OBSERVERS, physicsEngineObserver);
		}
		public function destroy():void {
			Observer.remove(PhysicsEngine.OBSERVERS, physicsEngineObserver);
		}
		
		//private
		private function onPhysicsEngineObserverNotify(sender:Object, event:String, data:Object):void {
			if (event == PhysicsEngineEvent.COLLIDE) {
				onCollide((data.body1 as Body).userData.parent as BaseObject, (data.body2 as Body).userData.parent as BaseObject);
			}
		}
		private function onCollide(obj1:BaseObject, obj2:BaseObject):void {
			collideCallback.apply(null, [obj1, obj2]);
		}
	}
}