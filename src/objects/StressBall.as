package objects {
	import egg82.patterns.prototype.interfaces.IPrototype;
	import objects.base.BaseCirclePhysicsObject;
	import objects.interfaces.ITriggerable;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class StressBall extends BaseCirclePhysicsObject implements IPrototype, ITriggerable {
		//vars
		private var gameType:String;
		
		//constructor
		public function StressBall(gameType:String, triggerCallback:Function) {
			this.gameType = gameType;
			this.triggerCallback = triggerCallback;
			super(gameType, "ball_standard", 15, 1);
		}
		
		//public
		public function clone():IPrototype {
			var c:StressBall = new StressBall(gameType, triggerCallback);
			c.create();
			return c;
		}
		
		//private
		
	}
}