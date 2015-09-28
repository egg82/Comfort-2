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

package egg82.custom {
	import egg82.enums.OptionsRegistryType;
	import egg82.events.custom.CustomImageEvent;
	import egg82.events.ImageDecoderEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.utils.ImageDecoder;
	import egg82.registry.interfaces.IRegistry;
	import egg82.utils.TextureUtil;
	import flash.display.BitmapData;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class CustomImage extends Image {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var loader:ImageDecoder = new ImageDecoder();
		private var path2:String;
		
		private var _isLoaded:Boolean = false;
		
		private var imageDecoderObserver:Observer = new Observer();
		
		private var _textureRegistry:IRegistry = ServiceLocator.getService("textureRegistry") as IRegistry;
		private var _optionsRegistry:IRegistry = ServiceLocator.getService("optionsRegistry") as IRegistry;
		
		//constructor
		public function CustomImage(url:String) {
			path2 = url.replace(/\W|_/g, "_");
			var texture:Texture = _textureRegistry.getRegister("null_tex");
			
			imageDecoderObserver.add(onImageDecoderObserverNotify);
			Observer.add(ImageDecoder.OBSERVERS, imageDecoderObserver);
			
			if (_textureRegistry.getRegister(path2 + "_tex")) {
				texture = _textureRegistry.getRegister(path2 + "_tex");
				_isLoaded = true;
				dispatch(CustomImageEvent.COMPLETE);
			} else if (_textureRegistry.getRegister(path2 + "_bmd")) {
				_textureRegistry.setRegister(path2 + "_tex", TextureUtil.getTexture(_textureRegistry.getRegister(path2 + "_bmd")));
				texture = _textureRegistry.getRegister(path2 + "_tex");
				_isLoaded = true;
				dispatch(CustomImageEvent.COMPLETE);
			} else {
				loader.load(url);
			}
			
			super(texture);
			
			smoothing = _optionsRegistry.getRegister(OptionsRegistryType.VIDEO).textureFiltering;
			touchable = false;
		}
		
		//public
		public function destroy():void {
			var name:String;
			
			Observer.remove(ImageDecoder.OBSERVERS, imageDecoderObserver);
			
			if (loader.file) {
				name = loader.file;
				name = name.replace(/\W|_/g, "_");
			} else {
				name = path2;
			}
			
			dispose();
			_textureRegistry.setRegister(path2 + "_tex", null);
			//RegTextures.disposeBMD(name);
		}
		
		public function get isLoaded():Boolean {
			return _isLoaded;
		}
		
		//private
		private function onImageDecoderObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== loader) {
				return;
			}
			
			if (event == ImageDecoderEvent.COMPLETE) {
				onLoadComplete(data as BitmapData);
			} else if (event == ImageDecoderEvent.ERROR) {
				onLoadError(data as String);
			} else if (event == ImageDecoderEvent.PROGRESS) {
				
			}
		}
		
		private function onLoadError(error:String):void {
			dispatch(CustomImageEvent.ERROR, error);
			
			var name:String = loader.file;
			name = name.replace(/\W|_/g, "_");
			
			if (_textureRegistry.getRegister(name + "_tex")) {
				texture = _textureRegistry.getRegister(name + "_tex");
			} else if (_textureRegistry.getRegister(name + "_bmd")) {
				_textureRegistry.setRegister(name + "_tex", TextureUtil.getTexture(_textureRegistry.getRegister(name + "_bmd")));
				texture = _textureRegistry.getRegister(name + "_tex");
			} else {
				return;
			}
			
			if (width == 1 && height == 1) {
				width = texture.width;
				height = texture.height;
			}
			
			_isLoaded = true;
			dispatch(CustomImageEvent.COMPLETE);
		}
		private function onLoadComplete(bmd:BitmapData):void {
			var name:String = loader.file;
			name = name.replace(/\W|_/g, "_");
			
			if (_textureRegistry.getRegister(name + "_tex")) {
				bmd.dispose();
				texture = _textureRegistry.getRegister(name + "_tex");
			} else if (_textureRegistry.getRegister(name + "_bmd")) {
				bmd.dispose();
				_textureRegistry.setRegister(name + "_tex", TextureUtil.getTexture(_textureRegistry.getRegister(name + "_bmd")));
				texture = _textureRegistry.getRegister(name + "_tex");
			} else {
				_textureRegistry.setRegister(name + "_bmd", bmd);
				_textureRegistry.setRegister(name + "_tex", TextureUtil.getTexture(_textureRegistry.getRegister(name + "_bmd")));
				texture = _textureRegistry.getRegister(name + "_tex");
			}
			
			if (width == 1 && height == 1) {
				width = texture.width;
				height = texture.height;
			}
			
			scaleX = scaleY = 1;
			
			_isLoaded = true;
			dispatch(CustomImageEvent.COMPLETE);
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}