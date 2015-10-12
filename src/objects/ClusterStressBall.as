package objects {
	import egg82.patterns.prototype.interfaces.IPrototype;
	import objects.base.BaseCirclePhysicsObject;
	import objects.interfaces.ITriggerable;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class ClusterStressBall extends BaseCirclePhysicsObject implements IPrototype, ITriggerable {
		//vars
		private var gameType:String;
		
		//constructor
		public function ClusterStressBall(gameType:String, triggerCallback:Function) {
			this.gameType = gameType;
			this.triggerCallback = triggerCallback;
			super(gameType, "ball_explosive_cluster", 4, 0.15);
		}
		
		//public
		public function clone():IPrototype {
			var c:ClusterStressBall = new ClusterStressBall(gameType, triggerCallback);
			c.create();
			return c;
		}
		
		//private
		
	}
}