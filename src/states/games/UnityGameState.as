package states.games {
	import enums.GameType;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class UnityGameState extends BaseGameState {
		//vars
		
		//constructor
		public function UnityGameState() {
			
		}
		
		//public
		override public function create(...args):void {
			super.create({
				"gameType": GameType.UNITY
			});
			
			physicsEngine.addBody(paddle1.body);
			addChild(paddle1);
			
			physicsEngine.addBody(paddle2.body);
			addChild(paddle2);
		}
		
		//private
		
	}
}