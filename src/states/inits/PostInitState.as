package states.inits {
	import egg82.base.BaseState;
	import enums.GameType;
	import states.AdState;
	import states.LoadingState;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class PostInitState extends BaseState {
		//vars
		private var gameType:String = GameType.HORDE;
		
		//constructor
		public function PostInitState() {
			
		}
		
		//public
		override public function create(...args):void {
			super.create();
			
			trace("postInit");
			
			//_nextState = AdState;
			_nextState = LoadingState;
			_nextStateParams = [{
				"gameType": GameType.UNITY
			}];
			nextState();
		}
		
		//private
		
	}
}