package states.loading {
	import egg82.custom.CustomImage;
	import egg82.engines.interfaces.IAudioEngine;
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.patterns.ServiceLocator;
	import enums.GameType;
	import states.games.HordeGameState;
	import states.games.MaskGameState;
	import states.games.NemesisGameState;
	import states.games.UnityGameState;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class GameLoadingState extends CustomLoadingState {
		//vars
		private var audioEngine:IAudioEngine = ServiceLocator.getService(ServiceType.AUDIO_ENGINE) as IAudioEngine;
		
		private var background:CustomImage;
		
		private var gameType:String;
		private var animations:Boolean;
		
		private var musicQuality:String;
		private var textureQuality:String;
		
		//constructor
		public function GameLoadingState() {
			
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
			
			musicQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.AUDIO, "musicQuality") as String;
			textureQuality = REGISTRY_UTIL.getOption(OptionsRegistryType.VIDEO, "textureQuality") as String;
			animations = REGISTRY_UTIL.getOption(OptionsRegistryType.VIDEO, "animations") as Boolean;
			
			background = new CustomImage(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, textureQuality + "_" + gameType + "_background"));
			background.create();
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;
			addChild(background);
			
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
			
			audioEngine.playAudio(musicQuality + "_music_jazz", true);
			super.create(args);
		}
		
		override public function destroy():void {
			audioEngine.pauseAudio(musicQuality + "_music_jazz");
			
			super.destroy();
		}
		
		//private
		
	}
}