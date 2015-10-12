package objects {
	import egg82.patterns.prototype.interfaces.IPrototype;
	import enums.objects.StarType;
	import objects.base.BaseStarPhysicsObject;
	import objects.interfaces.ITriggerable;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class RemedyStar extends BaseStarPhysicsObject implements IPrototype, ITriggerable {
		//vars
		private var gameType:String;
		
		//constructor
		public function RemedyStar(gameType:String, triggerCallback:Function) {
			this.gameType = gameType;
			this.triggerCallback = triggerCallback;
			super(gameType, StarType.REMEDY, 0);
		}
		
		//public
		public function clone():IPrototype {
			var c:RemedyStar = new RemedyStar(gameType, triggerCallback);
			c.create();
			return c;
		}
		
		//private
		
	}
}