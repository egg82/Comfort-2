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
			
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.MUSIC, "music_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "music_" + gameType));
			}
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.AMBIENT, "stress_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "stress_" + gameType));
			}
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.AMBIENT, "ball_hit_critical_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "ball_hit_critical_" + gameType));
			}
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.AMBIENT, "ball_hit_insecure_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "ball_hit_insecure_" + gameType));
			}
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.AMBIENT, "ball_hit_normal_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "ball_hit_normal_" + gameType));
			}
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.AMBIENT, "ball_miss_1_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "ball_miss_1_" + gameType));
			}
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.AMBIENT, "ball_miss_2_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "ball_miss_2_" + gameType));
			}
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.AMBIENT, "game_over_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "game_over_" + gameType));
			}
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.AMBIENT, "clock")) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "clock"));
			}
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.AMBIENT, "explosion")) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "explosion"));
			}
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.AMBIENT, "pause")) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "pause"));
			}
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.AMBIENT, "unpause")) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "unpause"));
			}
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.AMBIENT, "star_activation")) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "star_activation"));
			}
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.AMBIENT, "star_appearance")) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "star_appearance"));
			}
			if (!REGISTRY_UTIL.getAudio(AudioRegistryType.AMBIENT, "star_deactivation")) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "star_deactivation"));
			}
			if (gameType == GameType.HORDE) {
				if (!REGISTRY_UTIL.getAudio(AudioRegistryType.AMBIENT, "sentry_shoot")) {
					fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "sentry_shoot"));
				}
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
				REGISTRY_UTIL.setAudio(AudioRegistryType.MUSIC, "music_" + gameType, data);
				audioEngine.setAudio("music_" + gameType, AudioFileType.MP3, AudioType.MUSIC, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "stress_" + gameType))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.AMBIENT, "stress_" + gameType, data);
				audioEngine.setAudio("stress_" + gameType, AudioFileType.WAV, AudioType.AMBIENT, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "ball_hit_critical_" + gameType))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.SFX, "ball_hit_critical_" + gameType, data);
				audioEngine.setAudio("ball_hit_critical_" + gameType, AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "ball_hit_insecure_" + gameType))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.SFX, "ball_hit_insecure_" + gameType, data);
				audioEngine.setAudio("ball_hit_insecure_" + gameType, AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "ball_hit_normal_" + gameType))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.SFX, "ball_hit_normal_" + gameType, data);
				audioEngine.setAudio("ball_hit_normal_" + gameType, AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "ball_miss_1_" + gameType))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.SFX, "ball_miss_1_" + gameType, data);
				audioEngine.setAudio("ball_miss_1_" + gameType, AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "ball_miss_2_" + gameType))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.SFX, "ball_miss_2_" + gameType, data);
				audioEngine.setAudio("ball_miss_2_" + gameType, AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "game_over_" + gameType))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.SFX, "game_over_" + gameType, data);
				audioEngine.setAudio("game_over_" + gameType, AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "clock"))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.SFX, "clock", data);
				audioEngine.setAudio("clock", AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "explosion"))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.SFX, "explosion", data);
				audioEngine.setAudio("explosion", AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "pause"))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.SFX, "pause", data);
				audioEngine.setAudio("pause", AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "unpause"))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.SFX, "unpause", data);
				audioEngine.setAudio("unpause", AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "star_activation"))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.SFX, "star_activation", data);
				audioEngine.setAudio("star_activation", AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "star_appearance"))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.SFX, "star_appearance", data);
				audioEngine.setAudio("star_appearance", AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "star_deactivation"))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.SFX, "star_deactivation", data);
				audioEngine.setAudio("star_deactivation", AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, "sentry_shoot"))) {
				REGISTRY_UTIL.setAudio(AudioRegistryType.SFX, "sentry_shoot", data);
				audioEngine.setAudio("sentry_shoot", AudioFileType.WAV, AudioType.SFX, data);
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