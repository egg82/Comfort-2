package states.inits {
	import egg82.base.BaseLoadingState;
	import egg82.engines.interfaces.IAudioEngine;
	import egg82.enums.AudioFileType;
	import egg82.enums.AudioType;
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.events.base.BaseLoadingStateEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import enums.GameType;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import states.AdState;
	import states.LoadingState;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class PostInitState extends BaseLoadingState {
		//vars
		private var audioEngine:IAudioEngine = ServiceLocator.getService(ServiceType.AUDIO_ENGINE) as IAudioEngine;
		
		private var gameType:String = GameType.HORDE;
		
		private var baseLoadingStateObserver:Observer = new Observer();
		
		private var musicQuality:String;
		private var sfxQuality:String;
		private var textureQuality:String;
		
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
			
			musicQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "musicQuality");
			sfxQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "sfxQuality");
			textureQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.VIDEO, "textureQuality");
			
			baseLoadingStateObserver.add(onBaseLoadingStateObserverNotify);
			Observer.add(BaseLoadingState.OBSERVERS, baseLoadingStateObserver);
			
			var fileArr:Array = new Array();
			fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, musicQuality + "_music_main"));
			fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, musicQuality + "_music_jazz"));
			fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_select"));
			
			super.create({
				"fileArr": fileArr,
				"font": "note"
			});
		}
		
		//private
		private function onBaseLoadingStateObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== this) {
				return;
			}
			
			if (event == BaseLoadingStateEvent.DOWNLOAD_COMPLETE) {
				onDownloadComplete(data.name as String, data.data as ByteArray);
			} else if (event == BaseLoadingStateEvent.DECODE_COMPLETE) {
				onDecodeComplete(data.name as String, data.data as BitmapData);
			} else if (event == BaseLoadingStateEvent.COMPLETE) {
				onComplete();
			}
		}
		private function onDownloadComplete(name:String, data:ByteArray):void {
			if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, musicQuality + "_music_main"))) {
				audioEngine.setAudio(musicQuality + "_music_main", AudioFileType.MP3, AudioType.MUSIC, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, musicQuality + "_music_jazz"))) {
				audioEngine.setAudio(musicQuality + "_music_jazz", AudioFileType.MP3, AudioType.MUSIC, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, musicQuality + "_select"))) {
				audioEngine.setAudio(musicQuality + "_select", AudioFileType.WAV, AudioType.SFX, data);
			}
		}
		private function onDecodeComplete(name:String, data:BitmapData):void {
			
		}
		private function onComplete():void {
			
		}
	}
}