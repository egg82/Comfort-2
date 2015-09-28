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
	import egg82.events.custom.CustomAtlasImageEvent;
	import egg82.events.ImageDecoderEvent;
	import egg82.events.net.SimpleURLLoaderEvent;
	import egg82.net.SimpleURLLoader;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.utils.ImageDecoder;
	import egg82.utils.MathUtil;
	import egg82.utils.TextureUtil;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class CustomAtlasImage extends Image {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var loader:ImageDecoder = new ImageDecoder();
		private var xmlLoader:SimpleURLLoader = new SimpleURLLoader();
		
		private var atlas:TextureAtlas;
		private var path2:String;
		private var atlasRows:uint;
		private var atlasCols:uint;
		
		private var texRow:uint = 0;
		private var texCol:uint = 0;
		
		private var _isLoaded:Boolean = false;
		private var _xmlLoaded:Boolean = false;
		private var _bmd:BitmapData = null;
		
		private var imageDecoderObserver:Observer = new Observer();
		private var simpleURLLoaderObserver:Observer = new Observer();
		
		private var optionsRegistry:IRegistry = ServiceLocator.getService("optionsRegistry") as IRegistry;
		private var textureRegistry:IRegistry = ServiceLocator.getService("textureRegistry") as IRegistry;
		
		//constructor
		public function CustomAtlasImage(url:String, xmlUrl:String = null, atlasRows:uint = 0, atlasCols:uint = 0) {
			path2 = url.replace(/\W|_/g, "_");
			this.atlasRows = atlasRows;
			this.atlasCols = atlasCols;
			var texture:Texture = textureRegistry.getRegister("null_tex");
			
			imageDecoderObserver.add(onImageDecoderObserverNotify);
			Observer.add(ImageDecoder.OBSERVERS, imageDecoderObserver);
			simpleURLLoaderObserver.add(onSimpleURLLoaderObserverNotify);
			Observer.add(SimpleURLLoader.OBSERVERS, simpleURLLoaderObserver);
			
			if (textureRegistry.getRegister(path2 + "_atlas")) {
				atlas = textureRegistry.getRegister(path2 + "_atlas");
				texture = atlas.getTexture(atlas.getNames()[0]);
				_isLoaded = true;
				dispatch(CustomAtlasImageEvent.COMPLETE);
			} else if (textureRegistry.getRegister(path2 + "_tex")) {
				if (textureRegistry.getRegister(path2 + "_xml")) {
					textureRegistry.setRegister(path2 + "_atlas", TextureUtil.getTextureAtlasXML(textureRegistry.getRegister(path2 + "_tex"), textureRegistry.getRegister(path2 + "_xml")));
				} else {
					textureRegistry.setRegister(path2 + "_atlas", TextureUtil.getTextureAtlas(textureRegistry.getRegister(path2 + "_tex"), atlasRows, atlasCols));
				}
				atlas = textureRegistry.getRegister(path2 + "_atlas");
				texture = atlas.getTexture(atlas.getNames()[0]);
				_isLoaded = true;
				dispatch(CustomAtlasImageEvent.COMPLETE);
			} else if (textureRegistry.getRegister(path2 + "_bmd")) {
				textureRegistry.setRegister(path2 + "_tex", TextureUtil.getTexture(textureRegistry.getRegister(path2 + "_bmd")));
				if (textureRegistry.getRegister(path2 + "_xml")) {
					textureRegistry.setRegister(path2 + "_atlas", TextureUtil.getTextureAtlasXML(textureRegistry.getRegister(path2 + "_tex"), textureRegistry.getRegister(path2 + "_xml")));
				} else {
					textureRegistry.setRegister(path2 + "_atlas", TextureUtil.getTextureAtlas(textureRegistry.getRegister(path2 + "_tex"), atlasRows, atlasCols));
				}
				atlas = textureRegistry.getRegister(path2 + "_atlas");
				texture = atlas.getTexture(atlas.getNames()[0]);
				_isLoaded = true;
				dispatch(CustomAtlasImageEvent.COMPLETE);
			} else {
				loader.load(url);
				if (xmlUrl) {
					xmlLoader.load(xmlUrl);
				} else {
					_xmlLoaded = true;
				}
			}
			
			super(texture);
			
			smoothing = optionsRegistry.getRegister(OptionsRegistryType.VIDEO).textureFiltering;
			touchable = false;
		}
		
		//public
		public function destroy():void {
			var name:String;
			
			Observer.remove(ImageDecoder.OBSERVERS, imageDecoderObserver);
			Observer.remove(SimpleURLLoader.OBSERVERS, simpleURLLoaderObserver);
			
			if (loader.file) {
				name = loader.file;
				name = name.replace(/\W|_/g, "_");
			} else {
				name = path2;
			}
			
			dispose();
			textureRegistry.setRegister(name + "_atlas", null);
			textureRegistry.setRegister(name + "_xml", null);
			//RegTextures.disposeBMD(name);
		}
		
		public function setTexture(row:uint, col:uint):void {
			if (!atlas) {
				return;
			}
			
			texRow = row;
			texCol = col;
			
			if (!atlas.getTexture(col + "_" + row)) {
				texture = textureRegistry.getRegister("null_tex");
			} else {
				texture = atlas.getTexture(col + "_" + row);
			}
			
			scaleX = scaleY = 1;
		}
		public function setTextureFromName(name:String):void {
			if (!atlas) {
				return;
			}
			
			if (!atlas.getTexture(name)) {
				texture = textureRegistry.getRegister("null_tex");
			} else {
				texture = atlas.getTexture(name);
			}
			
			scaleX = scaleY = 1;
			
			readjustSize();
		}
		public function getTextureXY():uint {
			if (!atlas) {
				return 0;
			}
			
			return MathUtil.toXY(atlasCols, texCol, texRow);
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
		private function onSimpleURLLoaderObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== xmlLoader) {
				return;
			}
			
			if (event == SimpleURLLoaderEvent.COMPLETE) {
				onXMLLoadComplete(data as ByteArray);
			} else if (event == SimpleURLLoaderEvent.ERROR) {
				onXMLLoadError(data as String);
			} else if (event == SimpleURLLoaderEvent.PROGRESS) {
				
			}
		}
		
		private function onLoadError(error:String):void {
			dispatch(CustomAtlasImageEvent.ERROR, error);
			
			var name:String = loader.file;
			name = name.replace(/\W|_/g, "_");
			
			if (textureRegistry.getRegister(name + "_atlas")) {
				atlas = textureRegistry.getRegister(name + "_atlas");
			} else if (textureRegistry.getRegister(name + "_tex")) {
				if (textureRegistry.getRegister(path2 + "_xml")) {
					textureRegistry.setRegister(path2 + "_atlas", TextureUtil.getTextureAtlasXML(textureRegistry.getRegister(path2 + "_tex"), textureRegistry.getRegister(path2 + "_xml")));
				} else {
					textureRegistry.setRegister(path2 + "_atlas", TextureUtil.getTextureAtlas(textureRegistry.getRegister(path2 + "_tex"), atlasRows, atlasCols));
				}
				atlas = textureRegistry.getRegister(name + "_atlas");
			} else if (textureRegistry.getRegister(name + "_bmd")) {
				textureRegistry.setRegister(name + "_tex", TextureUtil.getTexture(textureRegistry.getRegister(name + "_bmd")));
				if (textureRegistry.getRegister(path2 + "_xml")) {
					textureRegistry.setRegister(path2 + "_atlas", TextureUtil.getTextureAtlasXML(textureRegistry.getRegister(path2 + "_tex"), textureRegistry.getRegister(path2 + "_xml")));
				} else {
					textureRegistry.setRegister(path2 + "_atlas", TextureUtil.getTextureAtlas(textureRegistry.getRegister(path2 + "_tex"), atlasRows, atlasCols));
				}
				atlas = textureRegistry.getRegister(name + "_atlas");
			} else {
				return;
			}
			
			texture = atlas.getTexture(atlas.getNames()[0]);
			
			if (width == 1 && height == 1) {
				width = texture.width;
				height = texture.height;
			}
			
			_isLoaded = true;
			dispatch(CustomAtlasImageEvent.COMPLETE);
		}
		private function onLoadComplete(bmd:BitmapData):void {
			_bmd = bmd;
			
			if (_xmlLoaded) {
				complete();
			}
		}
		
		private function onXMLLoadError(error:String):void {
			onLoadError(error);
		}
		private function onXMLLoadComplete(data:ByteArray):void {
			var name:String = loader.file;
			name = name.replace(/\W|_/g, "_");
			
			textureRegistry.setRegister(name + "_xml", new XML(data.readUTFBytes(data.length)));
			_xmlLoaded = true;
			
			if (_bmd) {
				complete();
			}
		}
		
		private function complete():void {
			var name:String = loader.file;
			name = name.replace(/\W|_/g, "_");
			
			if (textureRegistry.getRegister(name + "_atlas")) {
				_bmd.dispose();
				atlas = textureRegistry.getRegister(name + "_atlas");
			} else if (textureRegistry.getRegister(name + "_tex")) {
				_bmd.dispose();
				if (textureRegistry.getRegister(path2 + "_xml")) {
					textureRegistry.setRegister(path2 + "_atlas", TextureUtil.getTextureAtlasXML(textureRegistry.getRegister(path2 + "_tex"), textureRegistry.getRegister(path2 + "_xml")));
				} else {
					textureRegistry.setRegister(path2 + "_atlas", TextureUtil.getTextureAtlas(textureRegistry.getRegister(path2 + "_tex"), atlasRows, atlasCols));
				}
				atlas = textureRegistry.getRegister(name + "_atlas");
			} else if (textureRegistry.getRegister(name + "_bmd")) {
				_bmd.dispose();
				textureRegistry.setRegister(name + "_tex", TextureUtil.getTexture(textureRegistry.getRegister(name + "_bmd")));
				if (textureRegistry.getRegister(path2 + "_xml")) {
					textureRegistry.setRegister(path2 + "_atlas", TextureUtil.getTextureAtlasXML(textureRegistry.getRegister(path2 + "_tex"), textureRegistry.getRegister(path2 + "_xml")));
				} else {
					textureRegistry.setRegister(path2 + "_atlas", TextureUtil.getTextureAtlas(textureRegistry.getRegister(path2 + "_tex"), atlasRows, atlasCols));
				}
				atlas = textureRegistry.getRegister(name + "_atlas");
			} else {
				textureRegistry.setRegister(name + "_bmd", _bmd);
				textureRegistry.setRegister(name + "_tex", TextureUtil.getTexture(textureRegistry.getRegister(name + "_bmd")));
				if (textureRegistry.getRegister(path2 + "_xml")) {
					textureRegistry.setRegister(path2 + "_atlas", TextureUtil.getTextureAtlasXML(textureRegistry.getRegister(path2 + "_tex"), textureRegistry.getRegister(path2 + "_xml")));
				} else {
					textureRegistry.setRegister(path2 + "_atlas", TextureUtil.getTextureAtlas(textureRegistry.getRegister(path2 + "_tex"), atlasRows, atlasCols));
				}
				atlas = textureRegistry.getRegister(name + "_atlas");
			}
			
			texture = atlas.getTexture(atlas.getNames()[0]);
			
			if (width == 1 && height == 1) {
				width = texture.width;
				height = texture.height;
			}
			
			_bmd = null;
			_isLoaded = true;
			dispatch(CustomAtlasImageEvent.COMPLETE);
		}
		
		private function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}