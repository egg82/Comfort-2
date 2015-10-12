package states.inits {
	import egg82.base.BaseState;
	import enums.GameType;
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
		override public function create():void {
			super.create();
			
			trace("postInit");
			
			_nextState = LoadingState;
			nextState();
		}
		
		//private
		
	}
}