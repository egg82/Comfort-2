package states.games {
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
		override public function create(...args):void {
			super.create({
				"gameType": GameType.HORDE
			});
			
			physicsEngine.addBody(sentry.body);
			addChild(sentry);
			
			fireTimer.start();
		}
		
		//private
		
	}
}