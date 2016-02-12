package states.loading {
	import states.loading.CustomLoadingState;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class LogoLoadingState extends CustomLoadingState {
		//vars
		
		//constructor
		public function LogoLoadingState() {
			
		}
		
		//public
		override public function create(args:Array = null):void {
			_nextState = LogoState;
			
			sfxArr = new <String> [
				"fanfare"
			];
			
			super.create(args);
		}
		
		//private
		
	}
}