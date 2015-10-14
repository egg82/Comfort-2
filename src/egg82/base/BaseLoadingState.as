package egg82.base {
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.events.base.BaseLoadingStateEvent;
	import egg82.events.ImageDecoderEvent;
	import egg82.events.net.SimpleURLLoaderEvent;
	import egg82.net.SimpleURLLoader;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.utils.ImageDecoder;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class BaseLoadingState extends BaseState {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var font:String = "visitor";
		private var loadingString:String = "Loading..";
		private var fileArr:Array;
		
		private var centerText:TextField;
		
		private var imageDecoders:Vector.<ImageDecoder> = new Vector.<ImageDecoder>();
		
		private var urlLoaders:Vector.<SimpleURLLoader>;
		private var currentFile:uint;
		private var _loadedFiles:Number;
		private var _totalFiles:Number;
		
		private var _decodedFiles:Number;
		private var _totalDecodeFiles:Number;
		
		private var urlLoaderObserver:Observer = new Observer();
		private var imageDecoderObserver:Observer = new Observer();
		
		private var optionsRegistry:IRegistry = ServiceLocator.getService(ServiceType.OPTIONS_REGISTRY) as IRegistry;
		
		//constructor
		public function BaseLoadingState() {
			
		}
		
		//public
		override public function create(...args):void {
			super.create();
			
			throwErrorOnArgsNull(args);
			fileArr = getArg(args, "fileArr") as Array;
			if (getArg(args, "font")) {
				font = getArg(args, "font") as String;
				if (!font) {
					throw new Error("font cannot be null.");
				}
			}
			if (getArg(args, "loadingString")) {
				loadingString = getArg(args, "loadingString") as String;
				if (!loadingString) {
					throw new Error("loadingString cannot be null");
				}
			}
			
			if (!fileArr || fileArr.length == 0) {
				dispatch(BaseLoadingStateEvent.COMPLETE);
				nextState();
				return;
			}
			
			urlLoaderObserver.add(onUrlLoaderObserverNotify);
			Observer.add(SimpleURLLoader.OBSERVERS, urlLoaderObserver);
			
			imageDecoderObserver.add(onImageDecoderObserverNotify);
			Observer.add(ImageDecoder.OBSERVERS, imageDecoderObserver);
			
			centerText = new TextField(0, 0, loadingString + "\n0/0\n0.00%", font, 22, 0x000000, false);
			centerText.hAlign = HAlign.CENTER;
			centerText.vAlign = VAlign.CENTER;
			addChild(centerText);
			
			_loadedFiles = 0;
			_totalFiles = fileArr.length;
			_decodedFiles = 0;
			_totalDecodeFiles = 0;
			
			setLoadedFiles(0, _totalFiles);
			
			urlLoaders = new Vector.<SimpleURLLoader>();
			var toLoad:uint = currentFile = Math.min(optionsRegistry.getRegister(OptionsRegistryType.NETWORK).threads, _totalFiles);
			var loaded:uint = 0;
			
			currentFile--;
			
			while (loaded < toLoad) {
				urlLoaders.push(new SimpleURLLoader());
				urlLoaders[urlLoaders.length - 1].load(fileArr[loaded]);
				
				loaded++;
			}
		}
		
		override public function resize():void {
			super.resize();
			
			centerText.width = stage.stageWidth;
			centerText.height = stage.stageHeight;
		}
		
		override public function destroy():void {
			Observer.remove(SimpleURLLoader.OBSERVERS, urlLoaderObserver);
			Observer.remove(ImageDecoder.OBSERVERS, imageDecoderObserver);
			
			super.destroy();
		}
		
		//private
		protected function setLoadedFiles(loadedFiles:uint, totalFiles:uint):void {
			centerText.text = loadingString + "\n" + loadedFiles + "/" + totalFiles + "\n" + ((loadedFiles / totalFiles) * 100).toFixed(2) + "%";
		}
		
		protected function decodeImage(name:String, data:ByteArray):void {
			_totalDecodeFiles++;
			setLoadedFiles(_loadedFiles + _decodedFiles, _totalFiles + _totalDecodeFiles);
			
			imageDecoders.push(new ImageDecoder());
			imageDecoders[imageDecoders.length - 1].decode(data, name);
		}
		
		private function onUrlLoaderObserverNotify(sender:Object, event:String, data:Object):void {
			var isInVec:Boolean = false;
			
			for (var i:uint = 0; i < urlLoaders.length; i++) {
				if (sender === urlLoaders[i]) {
					isInVec = true;
					break;
				}
			}
			
			if (!isInVec) {
				return;
			}
			
			if (event == SimpleURLLoaderEvent.COMPLETE) {
				onUrlLoaderComplete(sender as SimpleURLLoader, data as ByteArray);
			} else if (event == SimpleURLLoaderEvent.ERROR) {
				dispatch(BaseLoadingStateEvent.ERROR, data);
				centerText.text = "Error loading file\n" + (data as String);
			}
		}
		
		private function onUrlLoaderComplete(loader:SimpleURLLoader, data:ByteArray):void {
			var name:String = REGISTRY_UTIL.stripURL(loader.file);
			
			dispatch(BaseLoadingStateEvent.DOWNLOAD_COMPLETE, {
				"name": name,
				"data": data
			});
			
			_loadedFiles++;
			setLoadedFiles(_loadedFiles + _decodedFiles, _totalFiles + _totalDecodeFiles);
			
			if (currentFile < _totalFiles - 1) {
				currentFile++;
				
				if (currentFile > _totalFiles - 1) {
					trace("Skipping loading file " + currentFile);
					
					if (_loadedFiles == _totalFiles && _decodedFiles == _totalDecodeFiles) {
						dispatch(BaseLoadingStateEvent.COMPLETE);
						nextState();
						return;
					}
				}
				
				loader.load(fileArr[currentFile]);
			} else {
				if (_loadedFiles == _totalFiles && _decodedFiles == _totalDecodeFiles) {
					dispatch(BaseLoadingStateEvent.COMPLETE);
					nextState();
				}
			}
		}
		
		private function onImageDecoderObserverNotify(sender:Object, event:String, data:Object):void {
			var isInVec:Boolean = false;
			
			for (var i:uint = 0; i < imageDecoders.length; i++) {
				if (sender === imageDecoders[i]) {
					isInVec = true;
					break;
				}
			}
			
			if (!isInVec) {
				return;
			}
			
			if (event == ImageDecoderEvent.COMPLETE) {
				onImageDecoderComplete(sender as ImageDecoder, data as BitmapData);
			} else if (event == ImageDecoderEvent.ERROR) {
				dispatch(BaseLoadingStateEvent.ERROR, data);
				centerText.text = "Error loading file\n" + (data as String);
			}
		}
		
		private function onImageDecoderComplete(decoder:ImageDecoder, data:BitmapData):void {
			var name:String = REGISTRY_UTIL.stripURL(decoder.file);
			
			dispatch(BaseLoadingStateEvent.DECODE_COMPLETE, {
				"name": name,
				"data": data
			});
			
			_decodedFiles++;
			setLoadedFiles(_loadedFiles + _decodedFiles, _totalFiles + _totalDecodeFiles);
			
			if (_loadedFiles == _totalFiles && _decodedFiles == _totalDecodeFiles) {
				dispatch(BaseLoadingStateEvent.COMPLETE);
				nextState();
			}
		}
		
		override protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}