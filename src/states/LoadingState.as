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
	import enums.CustomOptionsRegistryType;
	import enums.GameType;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import states.games.HordeGameState;
	import states.games.MaskGameState;
	import states.games.NemesisGameState;
	import states.games.UnityGameState;
	import util.CompressionUtil;
	
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
		private var compressTextures:Boolean;
		private var animations:Boolean;
		
		private var bmdArr:Vector.<String> = new <String>[];
		private var xmlArr:Vector.<String> = new <String>[];
		private var ambientArr:Vector.<String> = new <String>[];
		private var musicArr:Vector.<String> = new <String>[];
		private var sfxArr:Vector.<String> = new <String>[];
		
		//constructor
		public function LoadingState() {
			
		}
		
		//public
		override public function create(args:Array = null):void {
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
			
			ambientQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "ambientQuality") as String;
			musicQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "musicQuality") as String;
			sfxQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "sfxQuality") as String;
			textureQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.VIDEO, "textureQuality") as String;
			compressTextures = REGISTRY_UTIL.getOption(OptionsRegistryType.VIDEO, "compressTextures") as Boolean;
			animations = REGISTRY_UTIL.getOption(OptionsRegistryType.VIDEO, "animations") as Boolean;
			
			background = new CustomImage(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + gameType + "_background"));
			background.create();
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;
			addChild(background);
			
			baseLoadingStateObserver.add(onBaseLoadingStateObserverNotify);
			Observer.add(BaseLoadingState.OBSERVERS, baseLoadingStateObserver);
			
			bmdArr.push(gameType + "_background");
			bmdArr.push(gameType + "_background_pause");
			bmdArr.push(gameType);
			xmlArr.push(gameType);
			if (animations) {
				bmdArr.push("anim");
				xmlArr.push("anim");
			}
			ambientArr.push("stress_" + gameType);
			musicArr.push("music_" + gameType);
			sfxArr.push("ball_hit_critical_" + gameType);
			sfxArr.push("ball_hit_insecure_" + gameType);
			sfxArr.push("ball_hit_normal_" + gameType);
			sfxArr.push("ball_miss_1_" + gameType);
			sfxArr.push("ball_miss_2_" + gameType);
			sfxArr.push("game_over_" + gameType);
			sfxArr.push("clock");
			sfxArr.push("explosion");
			sfxArr.push("pause");
			sfxArr.push("unpause");
			sfxArr.push("star_appearance");
			sfxArr.push("star_activation");
			sfxArr.push("star_deactivation");
			if (gameType == GameType.HORDE) {
				sfxArr.push("sentry_shoot");
			}
			
			var fileArr:Array = new Array();
			var i:uint;
			
			for (i = 0; i < bmdArr.length; i++) {
				if (!REGISTRY_UTIL.getBitmapData(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + bmdArr[i]))) {
					fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + bmdArr[i]));
				} else {
					if (compressTextures) {
						CompressionUtil.decompressBMD(REGISTRY_UTIL.getBitmapData(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + bmdArr[i])));
					}
				}
			}
			for (i = 0; i < xmlArr.length; i++) {
				if (!REGISTRY_UTIL.getXML(REGISTRY_UTIL.getFile(FileRegistryType.XML, xmlArr[i]))) {
					fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.XML, xmlArr[i]));
				}
			}
			for (i = 0; i < ambientArr.length; i++) {
				if (!audioEngine.getAudio(ambientQuality + "_" + ambientArr[i])) {
					fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, ambientQuality + "_" + ambientArr[i]));
				}
			}
			for (i = 0; i < musicArr.length; i++) {
				if (!audioEngine.getAudio(musicQuality + "_" + musicArr[i])) {
					fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, musicQuality + "_" + musicArr[i]));
				}
			}
			for (i = 0; i < sfxArr.length; i++) {
				if (!audioEngine.getAudio(sfxQuality + "_" + sfxArr[i])) {
					fileArr.push(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_" + sfxArr[i]));
				}
			}
			
			audioEngine.playAudio(musicQuality + "_music_jazz", true);
			
			args = addArg(args, {
				"fileArr": fileArr,
				"font": "note"
			});
			super.create(args);
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
			var i:uint;
			
			for (i = 0; i < bmdArr.length; i++) {
				if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + bmdArr[i]))) {
					decodeImage(name, data);
				}
			}
			for (i = 0; i < xmlArr.length; i++) {
				if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.XML, xmlArr[i]))) {
					REGISTRY_UTIL.setXML(name, new XML(data.readUTFBytes(data.length)));
				}
			}
			for (i = 0; i < ambientArr.length; i++) {
				if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, ambientQuality + "_" + ambientArr[i]))) {
					audioEngine.setAudio(musicQuality + "_" + ambientArr[i], AudioFileType.MP3, AudioType.AMBIENT, data);
				}
			}
			for (i = 0; i < musicArr.length; i++) {
				if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, musicQuality + "_" + musicArr[i]))) {
					audioEngine.setAudio(musicQuality + "_" + musicArr[i], AudioFileType.MP3, AudioType.MUSIC, data);
				}
			}
			for (i = 0; i < sfxArr.length; i++) {
				if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.AUDIO, sfxQuality + "_" + sfxArr[i]))) {
					audioEngine.setAudio(sfxQuality + "_" + sfxArr[i], AudioFileType.WAV, AudioType.SFX, data);
				}
			}
		}
		private function onDecodeComplete(name:String, data:BitmapData):void {
			for (var i:uint = 0; i < bmdArr.length; i++) {
				if (name == REGISTRY_UTIL.stripURL(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + bmdArr[i]))) {
					REGISTRY_UTIL.setBitmapData(name, data);
				}
			}
		}
		private function onComplete():void {
			var i:uint;
			
			for (i = 0; i < bmdArr.length; i++) {
				if (!REGISTRY_UTIL.getTexture(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + bmdArr[i]))) {
					REGISTRY_UTIL.setTexture(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + bmdArr[i]), TextureUtil.getTexture(REGISTRY_UTIL.getBitmapData(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + bmdArr[i]))));
				}
			}
			for (i = 0; i < xmlArr.length; i++) {
				if (!REGISTRY_UTIL.getAtlas(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + xmlArr[i]))) {
					REGISTRY_UTIL.setAtlas(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + xmlArr[i]), TextureUtil.getTextureAtlasXML(REGISTRY_UTIL.getTexture(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + xmlArr[i])), REGISTRY_UTIL.getXML(REGISTRY_UTIL.getFile(FileRegistryType.XML, xmlArr[i]))));
				}
			}
		}
	}
}