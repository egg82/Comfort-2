package states {
	import egg82.base.BaseState;
	import egg82.custom.CustomImage;
	import egg82.engines.interfaces.IAudioEngine;
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.patterns.ServiceLocator;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class MenuState extends BaseState {
		//vars
		private var audioEngine:IAudioEngine = ServiceLocator.getService(ServiceType.AUDIO_ENGINE) as IAudioEngine;
		
		private var background:CustomImage;
		
		private var gameType:String;
		private var musicQuality:String;
		private var ambientQuality:String;
		private var sfxQuality:String;
		private var textureQuality:String;
		
		private var animations:Boolean;
		
		//constructor
		public function MenuState() {
			
		}
		
		//public
		override public function create(...args):void {
			ambientQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "ambientQuality");
			musicQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "musicQuality");
			sfxQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "sfxQuality");
			textureQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.VIDEO, "textureQuality");
			
			background = new CustomImage(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_background_menu"));
			background.create();
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;
			addChild(background);
			
			audioEngine.playAudio(musicQuality + "_music_main", true);
			
			super.create();
		}
		
		override public function update(deltaTime:Number):void {
			super.update(deltaTime);
		}
		override public function draw():void {
			super.draw();
		}

		//private
		
	}
}