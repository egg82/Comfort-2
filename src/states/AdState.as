package states {
	import com.newgrounds.components.FlashAd;
	import egg82.base.BaseState;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class AdState extends BaseState {
		//vars
		private var ad:FlashAd = new FlashAd();
		//private var playButton
		
		//constructor
		public function AdState() {
			
		}
		
		//public
		override public function create():void {
			super.create();
			
			_nextState = MenuState;
			
			ad.adType = ad.VIDEO_ADS;
			ad.showBorder = false;
			ad.showPlayButton = false;
			ad.x = stage.stageWidth / 2 - ad.width / 2;
			ad.y = stage.stageHeight / 2 - ad.height / 2;
			Starling.all[0].nativeOverlay.addChild(ad);
		}
		override public function destroy():void {
			Starling.all[0].nativeOverlay.removeChild(ad);
			
			super.destroy();
		}
		
		//private
		
	}
}