package states.games {
	import enums.CustomOptionsRegistryType;
	import enums.DifficultyType;
	import enums.GameType;
	import states.games.BaseGameState;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class HordeGameState extends BaseGameState {
		//vars
		
		//constructor
		public function HordeGameState() {
			
		}
		
		//public
		override public function create(args:Array = null):void {
			args = addArg(args, {
				"gameType": GameType.HORDE
			});
			super.create(args);
			
			physicsEngine.addBody(sentry.body);
			addChild(sentry.graphics);
		}
		
		//private
		
	}
}