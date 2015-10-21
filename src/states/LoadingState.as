package states {
	import egg82.base.BaseLoadingState;
	import egg82.custom.CustomImage;
	import egg82.engines.interfaces.IAudioEngine;
	import egg82.enums.AudioFileType;
	import egg82.enums.AudioType;
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
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
		private var musicQuality:String;
		private var ambientQuality:String;
		private var sfxQuality:String;
		private var textureQuality:String;
		
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
			
			ambientQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "ambientQuality");
			musicQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "musicQuality");
			sfxQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "sfxQuality");
			textureQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.VIDEO, "textureQuality");
			
			background = new CustomImage(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + gameType + "_background"));
			background.create();
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;
			addChild(background);
			
			baseLoadingStateObserver.add(onBaseLoadingStateObserverNotify);
			Observer.add(BaseLoadingState.OBSERVERS, baseLoadingStateObserver);
			
			var fileArr:Array = new Array();
			
			if (!REGISTRY_UTIL.getBitmapData(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + gameType + "_background"))) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + gameType + "_background"));
			}
			if (!REGISTRY_UTIL.getBitmapData(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + gameType))) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + gameType));
			}
			if (!REGISTRY_UTIL.getXML(REGISTRY_UTIL.getFile(FileRegistryType.XML, gameType))) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.XML, gameType));
			}
			
			if (!audioEngine.getAudio(musicQuality + "_music_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, musicQuality + "_music_" + gameType));
			}
			if (!audioEngine.getAudio(ambientQuality + "_stress_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, ambientQuality + "_stress_" + gameType));
			}
			if (!audioEngine.getAudio(sfxQuality + "_ball_hit_critical_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_ball_hit_critical_" + gameType));
			}
			if (!audioEngine.getAudio(sfxQuality + "_ball_hit_insecure_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_ball_hit_insecure_" + gameType));
			}
			if (!audioEngine.getAudio(sfxQuality + "_ball_hit_normal_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_ball_hit_normal_" + gameType));
			}
			if (!audioEngine.getAudio(sfxQuality + "_ball_miss_1_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_ball_miss_1_" + gameType));
			}
			if (!audioEngine.getAudio(sfxQuality + "_ball_miss_2_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_ball_miss_2_" + gameType));
			}
			if (!audioEngine.getAudio(sfxQuality + "_game_over_" + gameType)) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_game_over_" + gameType));
			}
			if (!audioEngine.getAudio(sfxQuality + "_clock")) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_clock"));
			}
			if (!audioEngine.getAudio(sfxQuality + "_explosion")) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_explosion"));
			}
			if (!audioEngine.getAudio(sfxQuality + "_pause")) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_pause"));
			}
			if (!audioEngine.getAudio(sfxQuality + "_unpause")) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_unpause"));
			}
			if (!audioEngine.getAudio(sfxQuality + "_star_activation")) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_star_activation"));
			}
			if (!audioEngine.getAudio(sfxQuality + "_star_appearance")) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_star_appearance"));
			}
			if (!audioEngine.getAudio(sfxQuality + "_star_deactivation")) {
				fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_star_deactivation"));
			}
			if (gameType == GameType.HORDE) {
				if (!audioEngine.getAudio(sfxQuality + "_sentry_shoot")) {
					fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_sentry_shoot"));
				}
			}
			
			audioEngine.playAudio(musicQuality + "_music_jazz", true);
			
			super.create({
				"fileArr": fileArr,
				"font": "note"
			});
		}
		
		override public function destroy():void {
			audioEngine.pauseAudio(musicQuality + "_music_jazz");
			
			super.destroy();
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
			if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + gameType))) {
				decodeImage(name, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.XML, gameType))) {
				REGISTRY_UTIL.setXML(name, new XML(data.readUTFBytes(data.length)));
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, musicQuality + "_music_" + gameType))) {
				audioEngine.setAudio(musicQuality + "_music_" + gameType, AudioFileType.MP3, AudioType.MUSIC, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, ambientQuality + "_stress_" + gameType))) {
				audioEngine.setAudio(ambientQuality + "_stress_" + gameType, AudioFileType.WAV, AudioType.AMBIENT, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_ball_hit_critical_" + gameType))) {
				audioEngine.setAudio(sfxQuality + "_ball_hit_critical_" + gameType, AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_ball_hit_insecure_" + gameType))) {
				audioEngine.setAudio(sfxQuality + "_ball_hit_insecure_" + gameType, AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_ball_hit_normal_" + gameType))) {
				audioEngine.setAudio(sfxQuality + "_ball_hit_normal_" + gameType, AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_ball_miss_1_" + gameType))) {
				audioEngine.setAudio(sfxQuality + "_ball_miss_1_" + gameType, AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_ball_miss_2_" + gameType))) {
				audioEngine.setAudio(sfxQuality + "_ball_miss_2_" + gameType, AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_game_over_" + gameType))) {
				audioEngine.setAudio(sfxQuality + "_game_over_" + gameType, AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_clock"))) {
				audioEngine.setAudio(sfxQuality + "_clock", AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_explosion"))) {
				audioEngine.setAudio(sfxQuality + "_explosion", AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_pause"))) {
				audioEngine.setAudio(sfxQuality + "_pause", AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_unpause"))) {
				audioEngine.setAudio(sfxQuality + "_unpause", AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_star_activation"))) {
				audioEngine.setAudio(sfxQuality + "_star_activation", AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_star_appearance"))) {
				audioEngine.setAudio(sfxQuality + "_star_appearance", AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_star_deactivation"))) {
				audioEngine.setAudio(sfxQuality + "_star_deactivation", AudioFileType.WAV, AudioType.SFX, data);
			} else if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_sentry_shoot"))) {
				audioEngine.setAudio(sfxQuality + "_sentry_shoot", AudioFileType.WAV, AudioType.SFX, data);
			}
		}
		private function onDecodeComplete(name:String, data:BitmapData):void {
			if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + gameType))) {
				REGISTRY_UTIL.setBitmapData(name, data);
				REGISTRY_UTIL.setTexture(name, TextureUtil.getTexture(data));
			}
		}
		private function onComplete():void {
			var url:String = REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + gameType);
			var xmlURL:String = REGISTRY_UTIL.getFile(FileRegistryType.XML, gameType);
			
			REGISTRY_UTIL.setAtlas(url, TextureUtil.getTextureAtlasXML(REGISTRY_UTIL.getTexture(url), REGISTRY_UTIL.getXML(xmlURL)));
		}
	}
}