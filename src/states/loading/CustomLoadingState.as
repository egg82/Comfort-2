package states.loading {
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
	import egg82.utils.TextureUtil;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import util.CompressionUtil;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class CustomLoadingState extends BaseLoadingState {
		//vars
		private var audioEngine:IAudioEngine = ServiceLocator.getService(ServiceType.AUDIO_ENGINE) as IAudioEngine;
		
		private var baseLoadingStateObserver:Observer = new Observer();
		
		private var musicQuality:String;
		private var ambientQuality:String;
		private var sfxQuality:String;
		private var textureQuality:String;
		private var compressTextures:Boolean;
		
		protected var bmdArr:Vector.<String> = new <String>[];
		protected var xmlArr:Vector.<String> = new <String>[];
		protected var ambientArr:Vector.<String> = new <String>[];
		protected var musicArr:Vector.<String> = new <String>[];
		protected var sfxArr:Vector.<String> = new <String>[];
		
		//constructor
		public function CustomLoadingState() {
			
		}
		
		//public
		override public function create(args:Array = null):void {
			ambientQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "ambientQuality") as String;
			musicQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "musicQuality") as String;
			sfxQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "sfxQuality") as String;
			textureQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.VIDEO, "textureQuality") as String;
			compressTextures = REGISTRY_UTIL.getOption(OptionsRegistryType.VIDEO, "compressTextures") as Boolean;
			
			baseLoadingStateObserver.add(onBaseLoadingStateObserverNotify);
			Observer.add(BaseLoadingState.OBSERVERS, baseLoadingStateObserver);
			
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
			
			args = addArg(args, {
				"fileArr": fileArr,
				"font": "note"
			});
			super.create(args);
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