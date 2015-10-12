package objects {
	import egg82.patterns.prototype.interfaces.IPrototype;
	import enums.objects.StarType;
	import objects.base.BaseStarPhysicsObject;
	import objects.interfaces.ITriggerable;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class ReliefStar extends BaseStarPhysicsObject implements IPrototype, ITriggerable {
		//vars
		private var gameType:String;
		
		//constructor
		public function ReliefStar(gameType:String, triggerCallback:Function) {
			this.gameType = gameType;
			this.triggerCallback = triggerCallback;
			super(gameType, StarType.RELIEF, 0);
		}
		
		//public
		public function clone():IPrototype {
			var c:ReliefStar = new ReliefStar(gameType, triggerCallback);
			c.create();
			return c;
		}
		
		//private
		
	}
}