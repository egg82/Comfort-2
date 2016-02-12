package states.loading {
	import states.loading.CustomLoadingState;
	import states.MenuState;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class MenuLoadingState extends CustomLoadingState {
		//vars
		
		//constructor
		public function MenuLoadingState() {
			
		}
		
		//public
		override public function create(args:Array = null):void {
			_nextState = MenuState;
			
			bmdArr = new <String> [
				"background_menu",
				"background_menu_credits",
				"background_menu_options",
				"background_menu_horde",
				"background_menu_mask",
				"background_menu_nemesis",
				"background_menu_unity"
			];
			musicArr = new <String> [
				"music_main",
				"music_jazz"
			];
			sfxArr = new <String> [
				"select"
			];
			
			super.create(args);
		}
		
		//private
		
	}
}