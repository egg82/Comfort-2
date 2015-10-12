package states {
	import egg82.base.BaseLoadingState;
	import egg82.custom.CustomImage;
	import egg82.enums.FileRegistryType;
	import egg82.events.base.BaseLoadingStateEvent;
	import egg82.patterns.Observer;
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
		private var baseLoadingStateObserver:Observer = new Observer();
		
		private var gameType:String = GameType.HORDE;
		
		private var background:CustomImage;
		
		//constructor
		public function LoadingState() {
			
		}
		
		//public
		override public function create():void {
			font = "note";
			if (gameType == GameType.HORDE) {
				_nextState = HordeGameState;
			} else if (gameType == GameType.MASK) {
				_nextState = MaskGameState;
			} else if (gameType == GameType.NEMESIS) {
				_nextState = NemesisGameState;
			} else {
				_nextState = UnityGameState;
			}
			
			background = new CustomImage(registryUtil.getFile(FileRegistryType.TEXTURE, gameType + "_background"));
			background.create();
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;
			addChild(background);
			
			baseLoadingStateObserver.add(onBaseLoadingStateObserverNotify);
			Observer.add(BaseLoadingState.OBSERVERS, baseLoadingStateObserver);
			
			if (!registryUtil.getBitmapData(registryUtil.getFile(FileRegistryType.TEXTURE, gameType + "_background"))) {
				fileArr.push(registryUtil.getFile(FileRegistryType.TEXTURE, gameType + "_background"));
			}
			if (!registryUtil.getBitmapData(registryUtil.getFile(FileRegistryType.TEXTURE, gameType))) {
				fileArr.push(registryUtil.getFile(FileRegistryType.TEXTURE, gameType));
			}
			if (!registryUtil.getXML(registryUtil.getFile(FileRegistryType.XML, gameType))) {
				fileArr.push(registryUtil.getFile(FileRegistryType.XML, gameType));
			}
			
			super.create();
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
			if (name == registryUtil.stripURL(registryUtil.getFile(FileRegistryType.TEXTURE, gameType))) {
				decodeImage(name, data);
			} else if (name == registryUtil.stripURL(registryUtil.getFile(FileRegistryType.XML, gameType))) {
				registryUtil.addXML(name, new XML(data.readUTFBytes(data.length)));
			}
		}
		private function onDecodeComplete(name:String, data:BitmapData):void {
			if (name == registryUtil.stripURL(registryUtil.getFile(FileRegistryType.TEXTURE, gameType))) {
				registryUtil.addBitmapData(name, data);
				registryUtil.addTexture(name, TextureUtil.getTexture(data));
			}
		}
		private function onComplete():void {
			var url:String = registryUtil.getFile(FileRegistryType.TEXTURE, gameType);
			var xmlURL:String = registryUtil.getFile(FileRegistryType.XML, gameType);
			
			registryUtil.addAtlas(url, TextureUtil.getTextureAtlasXML(registryUtil.getTexture(url), registryUtil.getXML(xmlURL)));
		}
	}
}