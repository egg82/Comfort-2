package {
	import egg82.base.BasePreloader;
	import egg82.events.base.BasePreloaderEvent;
	import egg82.patterns.Observer;
	import states.inits.PostInitState;
	import states.inits.PreInitState;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class Preloader extends BasePreloader {
		//vars
		private var preloaderObserver:Observer = new Observer();
		
		//constructor
		public function Preloader() {
			preloaderObserver.add(onPreloaderObserverNotify);
			Observer.add(BasePreloader.OBSERVERS, preloaderObserver);
			
			super(PreInitState, PostInitState);
		}
		
		//public
		
		//private
		private function onPreloaderObserverNotify(sender:Object, event:String, data:Object):void {
			if (event == BasePreloaderEvent.PROGRESS) {
				onProgress(data.loaded as Number, data.total as Number);
			} else if (event == BasePreloaderEvent.COMPLETE) {
				onComplete();
			}
		}
		
		private function onProgress(loaded:Number, total:Number):void {
			
		}
		private function onComplete():void {
			Observer.remove(BasePreloader.OBSERVERS, preloaderObserver);
			start();
		}
	}
}