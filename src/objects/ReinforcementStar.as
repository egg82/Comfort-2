package objects {
	import egg82.patterns.prototype.interfaces.IPrototype;
	import enums.objects.StarType;
	import objects.base.BaseStarPhysicsObject;
	import objects.interfaces.ITriggerable;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class ReinforcementStar extends BaseStarPhysicsObject implements IPrototype, ITriggerable {
		//vars
		private var gameType:String;
		
		//constructor
		public function ReinforcementStar(gameType:String, triggerCallback:Function) {
			this.gameType = gameType;
			this.triggerCallback = triggerCallback;
			super(gameType, StarType.REINFORCEMENT, -1.5);
		}
		
		//public
		public function clone():IPrototype {
			var c:ReinforcementStar = new ReinforcementStar(gameType, triggerCallback);
			c.create();
			return c;
		}
		
		//private
		
	}
}