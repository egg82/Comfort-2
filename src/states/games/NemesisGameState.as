package states.games {
	import enums.GameType;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class NemesisGameState extends BaseGameState {
		//vars
		
		//constructor
		public function NemesisGameState() {
			
		}
		
		//public
		override public function create(...args):void {
			super.create({
				"gameType": GameType.NEMESIS
			});
			
			physicsEngine.addBody(paddle1.body);
			addChild(paddle1);
		}
		
		//private
		
	}
}