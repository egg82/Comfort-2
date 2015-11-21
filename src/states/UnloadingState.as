package states {
	import egg82.base.BaseState;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import flash.display.BitmapData;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import util.CompressionUtil;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class UnloadingState extends BaseState {
		//vars
		private var textureRegistry:IRegistry = ServiceLocator.getService(ServiceType.TEXTURE_REGISTRY) as IRegistry;
		
		private var compressTextures:Boolean;
		
		//constructor
		public function UnloadingState() {
			
		}
		
		//public
		override public function create(...args):void {
			super.create();
			
			throwErrorOnArgsNull(args);
			
			_nextState = getArg(args, "nextState") as Class;
			_nextStateParams = getArg(args, "nextStateParams") as Array;
			if (!_nextState) {
				throw new Error("nextState cannot be null.");
			}
			
			compressTextures = REGISTRY_UTIL.getOption(OptionsRegistryType.VIDEO, "compressTextures") as Boolean;
			
			if (compressTextures) {
				var names:Vector.<String> = textureRegistry.registryNames;
				
				for (var i:uint = 0; i < names.length; i++) {
					var obj:* = textureRegistry.getRegister(names[i]);
					
					if (obj is Texture || obj is TextureAtlas) {
						textureRegistry.setRegister(names[i], null);
					} else if (obj is BitmapData) {
						CompressionUtil.decompressBMD(obj as BitmapData);
						CompressionUtil.compressBMD(obj as BitmapData, (names[i].indexOf("_png") > -1) ? true : false);
					}
				}
			}
			
			nextState();
		}
		
		//private
		
	}
}