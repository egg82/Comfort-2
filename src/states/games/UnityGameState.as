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
		override public function create(args:Array = null):void {
			args = addArg(args, {
				"gameType": GameType.UNITY
			});
			super.create(args);
			
			physicsEngine.addBody(paddle1.body);
			addChild(paddle1.graphics);
			
			physicsEngine.addBody(paddle2.body);
			addChild(paddle2.graphics);
		}
		
		//private
		
	}
}