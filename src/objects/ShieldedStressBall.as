package objects {
	import egg82.patterns.prototype.interfaces.IPrototype;
	import objects.base.BaseCirclePhysicsObject;
	import objects.interfaces.ITriggerable;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class ShieldedStressBall extends BaseCirclePhysicsObject implements IPrototype, ITriggerable {
		//vars
		private var gameType:String;
		
		//constructor
		public function ShieldedStressBall(gameType:String, triggerCallback:Function) {
			this.gameType = gameType;
			this.triggerCallback = triggerCallback;
			super(gameType, "ball_shielded", 14, 1);
			
			body.allowRotation = true;
			body.applyAngularImpulse(100);
		}
		
		//public
		public function clone():IPrototype {
			var c:ShieldedStressBall = new ShieldedStressBall(gameType, triggerCallback);
			c.create();
			return c;
		}
		
		//private
		
	}
}