package states.games {
	import enums.CustomOptionsRegistryType;
	import enums.DifficultyType;
	import enums.GameType;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class MaskGameState extends BaseGameState {
		//vars
		private var difficulty:String;
		
		//constructor
		public function MaskGameState() {
			
		}
		
		//public
		override public function create(...args):void {
			difficulty = REGISTRY_UTIL.getOption(CustomOptionsRegistryType.GAMEPLAY, "difficulty") as String;
			
			if (difficulty == DifficultyType.EASY) {
				
			} else if (difficulty == DifficultyType.MEDIUM) {
				
			} else if (difficulty == DifficultyType.HARD) {
				
			} else if (difficulty == DifficultyType.EXTREME) {
				
			}
			
			super.create({
				"gameType": GameType.MASK
			});
			
			physicsEngine.addBody(paddle1.body);
			addChild(paddle1.graphics);
		}
		
		//private
		
	}
}