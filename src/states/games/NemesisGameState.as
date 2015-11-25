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
		override public function create(args:Array = null):void {
			args = addArg(args, {
				"gameType": GameType.NEMESIS
			});
			super.create(args);
			
			physicsEngine.addBody(paddle1.body);
			addChild(paddle1.graphics);
		}
		
		//private
		
	}
}