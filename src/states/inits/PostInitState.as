package states.inits {
	import egg82.base.BaseState;
	import enums.GameType;
	import states.LoadingState;
	import states.MenuLoadingState;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class PostInitState extends BaseState {
		//vars
		private var gameType:String = GameType.MASK;
		
		//constructor
		public function PostInitState() {
			
		}
		
		//public
		override public function create(...args):void {
			trace("postInit");
			
			//_nextState = AdState;
			_nextState = LoadingState;
			_nextStateParams = [{
				"gameType": gameType
			}];
			//_nextState = MenuLoadingState;
			
			nextState();
			
			super.create();
		}
		
		//private
		
	}
}