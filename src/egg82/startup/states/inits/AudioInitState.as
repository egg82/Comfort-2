/**
 * Copyright (c) 2015 egg82 (Alexander Mason)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package egg82.startup.states.inits {
	import egg82.base.BaseState;
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
	import egg82.events.net.SimpleURLLoaderEvent;
	import egg82.net.SimpleURLLoader;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.startup.Start;
	import egg82.registry.interfaces.IRegistry;
	import flash.utils.ByteArray;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class AudioInitState extends BaseState {
		//vars
		private var centerText:TextField;
		
		private var urlLoaders:Vector.<SimpleURLLoader>;
		private var currentFile:uint;
		private var loadedFiles:Number;
		private var totalFiles:Number;
		
		private var urlLoaderObserver:Observer = new Observer();
		
		private var optionsRegistry:IRegistry = ServiceLocator.getService("optionsRegistry") as IRegistry;
		private var audioRegistry:IRegistry = ServiceLocator.getService("audioRegistry") as IRegistry;
		private var fileRegistry:IRegistry = ServiceLocator.getService("fileRegistry") as IRegistry;
		private var initRegistry:IRegistry = ServiceLocator.getService("initRegistry") as IRegistry;
		
		//constructor
		public function AudioInitState() {
			
		}
		
		//public
		override public function create():void {
			super.create();
			
			_nextState = initRegistry.getRegister("postInitState") as Class;
			
			if (!optionsRegistry.getRegister(OptionsRegistryType.NETWORK).preloadAudio || (fileRegistry.getRegister(FileRegistryType.AUDIO) as Array).length == 0) {
				nextState();
				return;
			}
			
			urlLoaderObserver.add(onUrlLoaderObserverNotify);
			Observer.add(SimpleURLLoader.OBSERVERS, urlLoaderObserver);
			
			centerText = new TextField(0, 0, "Loading audio", "visitor", 22, 0x000000, false);
			centerText.hAlign = HAlign.CENTER;
			centerText.vAlign = VAlign.CENTER;
			addChild(centerText);
			
			var fileArr:Array = fileRegistry.getRegister(FileRegistryType.AUDIO) as Array;
			loadedFiles = 0;
			totalFiles = fileArr.length;
			
			centerText.text = "Loading audio\n" + loadedFiles + "/" + totalFiles + "\n" + ((loadedFiles / totalFiles) * 100).toFixed(2) + "%";
			
			urlLoaders = new Vector.<SimpleURLLoader>();
			var toLoad:uint = currentFile = Math.min(optionsRegistry.getRegister(OptionsRegistryType.NETWORK).threads, totalFiles);
			var loaded:uint = 0;
			
			currentFile--;
			
			while (loaded < toLoad) {
				urlLoaders.push(new SimpleURLLoader());
				urlLoaders[urlLoaders.length - 1].load(fileArr[loaded].url);
				
				loaded++;
			}
		}
		
		override public function resize():void {
			super.resize();
			
			centerText.width = stage.stageWidth;
			centerText.height = stage.stageHeight;
		}
		
		override public function destroy():void {
			super.destroy();
			
			Observer.remove(SimpleURLLoader.OBSERVERS, urlLoaderObserver);
		}
		
		//private
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
				centerText.text = "Error loading file\n" + (data as String);
			}
		}
		
		private function onUrlLoaderComplete(loader:SimpleURLLoader, data:ByteArray):void {
			var name:String = loader.file;
			name = name.replace(/\W|_/g, "_");
			audioRegistry.setRegister(name, data);
			
			loadedFiles++;
			centerText.text = "Loading audio\n" + loadedFiles + "/" + totalFiles + "\n" + ((loadedFiles / totalFiles) * 100).toFixed(2) + "%";
			
			if (currentFile < totalFiles - 1) {
				currentFile++;
				
				if (currentFile > totalFiles - 1) {
					trace("Skipping loading file " + currentFile);
					
					if (loadedFiles == totalFiles) {
						nextState();
						return;
					}
				}
				
				loader.load((fileRegistry.getRegister(FileRegistryType.AUDIO) as Array)[currentFile].url);
			} else {
				if (loadedFiles == totalFiles) {
					nextState();
				}
			}
		}
	}
}