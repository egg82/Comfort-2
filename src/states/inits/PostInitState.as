package states.inits {
	import egg82.base.BaseState;
	import enums.GameType;
	import states.AdState;
	import states.loading.GameLoadingState;
	import states.loading.LogoLoadingState;
	import states.loading.MenuLoadingState;
	
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
		override public function create(args:Array = null):void {
			trace("postInit");
			
			//_nextState = AdState;
			_nextState = GameLoadingState;
			_nextStateParams = [{
				"gameType": gameType
			}];
			//_nextState = MenuLoadingState;
			//_nextState = LogoLoadingState;
			
			nextState();
			
			super.create(args);
		}
		
		//private
		
	}
}