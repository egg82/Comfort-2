package states {
	import egg82.base.BaseLoadingState;
	import egg82.custom.CustomImage;
	import egg82.engines.interfaces.IAudioEngine;
	import egg82.enums.AudioFileType;
	import egg82.enums.AudioRegistryType;
	import egg82.enums.AudioType;
	import egg82.enums.FileRegistryType;
	import egg82.enums.ServiceType;
	import egg82.events.base.BaseLoadingStateEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.utils.TextureUtil;
	import enums.GameType;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import states.games.HordeGameState;
	import states.games.MaskGameState;
	import states.games.NemesisGameState;
	import states.games.UnityGameState;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class LoadingState extends BaseLoadingState {
		//vars
		private var audioEngine:IAudioEngine = ServiceLocator.getService(ServiceType.AUDIO_ENGINE) as IAudioEngine;
		
		private var baseLoadingStateObserver:Observer = new Observer();
		
		private var background:CustomImage;
		
		private var gameType:String;
		
		//constructor
		public function LoadingState() {
			
		}
		
		//public
		override public function create(...args):void {
			throwErrorOnArgsNull(args);
			
			gameType = getArg(args, "gameType") as String;
			if (!gameType) {
				throw new Error("gameType cannot be null.");
			}
			
			if (gameType == GameType.HORDE) {
				_nextState = HordeGameState;
			} else if (gameType == GameType.MASK) {
				_nextState = MaskGameState;
			} else if (gameType == GameType.NEMESIS) {
				_nextState = NemesisGameState;
			} else {
				_nextState = UnityGameState;
			}
			
			background = new CustomImage(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, gameType + "_background"));
			background.create();
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;
			addChild(background);
			
			baseLoadingStateObserver.add(onBaseLoadingStateObserverNotify);
			Observer.add(BaseLoadingState.OBSERVERS, baseLoadingStateObserver);
			
			var fileArr:Array = new Array();
			
			if (!REGISTRY_UTIL.getBitmapData(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, gameType + "_background"))) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, gameType + "_background"));
			}
			if (!REGISTRY_UTIL.getBitmapData(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, gameType))) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, gameType));
			}
			if (!REGISTRY_UTIL.getXML(REGISTRY_UTIL.getFile(FileRegistryType.XML, gameType))) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.XML, gameType));
			}
			
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.MUSIC, gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "music_" + gameType));
			}
			
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
			if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, gameType))) {
				decodeImage(name, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.XML, gameType))) {
				REGISTRY_UTIL.setXML(name, new XML(data.readUTFBytes(data.length)));
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "music_" + gameType))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.MUSIC, gameType, data);
				audioEngine.setAudio("music_" + gameType, AudioFileType.MP3, AudioType.MUSIC, data);
			}
		}
		private function onDecodeComplete(name:String, data:BitmapData):void {
			if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, gameType))) {
				REGISTRY_UTIL.setBitmapData(name, data);
				REGISTRY_UTIL.setTexture(name, TextureUtil.getTexture(data));
			}
		}
		private function onComplete():void {
			var url:String = REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, gameType);
			var xmlURL:String = REGISTRY_UTIL.getFile(FileRegistryType.XML, gameType);
			
			REGISTRY_UTIL.setAtlas(url, TextureUtil.getTextureAtlasXML(REGISTRY_UTIL.getTexture(url), REGISTRY_UTIL.getXML(xmlURL)));
		}
	}
}