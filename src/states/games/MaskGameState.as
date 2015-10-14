package states.games {
	import enums.GameType;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class MaskGameState extends BaseGameState {
		//vars
		
		//constructor
		public function MaskGameState() {
			
		}
		
		//public
		override public function create(...args):void {
			super.create({
				"gameType": GameType.MASK
			});
			
			physicsEngine.addBody(paddle1.body);
			addChild(paddle1);
		}
		
		//private
		
	}
}