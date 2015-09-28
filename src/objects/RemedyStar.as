package objects {
	import egg82.patterns.prototype.interfaces.IPrototype;
	import enums.objects.StarType;
	import objects.base.BaseStarPhysicsObject;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class RemedyStar extends BaseStarPhysicsObject implements IPrototype {
		//vars
		private var gameType:String;
		
		//constructor
		public function RemedyStar(gameType:String) {
			this.gameType = gameType;
			super(gameType, StarType.REMEDY);
		}
		
		//public
		public function clone():IPrototype {
			return new RemedyStar(gameType);
		}
		
		//private
		
	}
}