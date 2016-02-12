package states {
	import egg82.base.BaseState;
	import egg82.engines.interfaces.IAudioEngine;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.patterns.ServiceLocator;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import starling.core.Starling;
	import states.loading.MenuLoadingState;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class LogoState extends BaseState {
		//vars
		[Embed(source = "../../res/swf/logo.swf", mimeType = "application/octet-stream")]
		private const LOGO:Class;
		
		private var audioEngine:IAudioEngine = ServiceLocator.getService(ServiceType.AUDIO_ENGINE) as IAudioEngine;
		
		private var musicQuality:String;
		private var sfxQuality:String;
		
		private var loader:Loader = new Loader();
		private var checkLoad:Boolean = false;
		
		//constructor
		public function LogoState() {
			
		}
		
		//public
		override public function create(args:Array = null):void {
			super.create(args);
			
			_nextState = MenuLoadingState;
			
			musicQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "musicQuality");
			sfxQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "sfxQuality");
			
			loader.loadBytes(new LOGO() as ByteArray);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAnimLoaded);
			
			audioEngine.playAudio(sfxQuality + "_fanfare");
		}
		
		override public function update(deltaTime:Number):void {
			super.update(deltaTime);
			
			if (checkLoad && loader.stage) {
				checkLoad = false;
				loader.stage.addEventListener(Event.COMPLETE, onAnimComplete);
			}
		}
		
		//private
		private function onAnimLoaded(e:Event):void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onAnimLoaded);
			
			checkLoad = true;
			Starling.current.nativeStage.addChild(loader);
		}
		private function onAnimComplete(e:Event):void {
			loader.stage.removeEventListener(Event.COMPLETE, onAnimComplete);
			
			Starling.current.nativeStage.removeChild(loader);
			loader.unloadAndStop();
			nextState();
		}
	}
}