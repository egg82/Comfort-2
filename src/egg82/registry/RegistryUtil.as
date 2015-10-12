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

package egg82.registry {
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.registry.interfaces.IRegistryUtil;
	import flash.display.BitmapData;
	import flash.text.Font;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class RegistryUtil implements IRegistryUtil {
		//vars
		private var fileRegistry:IRegistry;
		private var fontRegistry:IRegistry;
		private var optionsRegistry:IRegistry;
		private var textureRegistry:IRegistry;
		
		//constructor
		public function RegistryUtil() {
			
		}
		
		//public
		public function initialize():void {
			fileRegistry = ServiceLocator.getService("fileRegistry") as IRegistry;
			fontRegistry = ServiceLocator.getService("fontRegistry") as IRegistry;
			optionsRegistry = ServiceLocator.getService("optionsRegistry") as IRegistry;
			textureRegistry = ServiceLocator.getService("textureRegistry") as IRegistry;
			
			fileRegistry.initialize();
			fontRegistry.initialize();
			optionsRegistry.initialize();
			textureRegistry.initialize();
		}
		
		public function addFile(type:String, name:String, url:String):void {
			if (!fileRegistry.getRegister(type)) {
				fileRegistry.setRegister(type, new Array());
			}
			
			(fileRegistry.getRegister(type) as Array).push({
				"name": name,
				"url": url
			});
		}
		public function getFile(type:String, name:String):String {
			if (!fileRegistry.getRegister(type)) {
				return null;
			}
			
			var arr:Array = fileRegistry.getRegister(type) as Array;
			
			for (var i:uint = 0; i < arr.length; i++) {
				if (arr[i].name == name) {
					return arr[i].url as String;
				}
			}
			
			return null;
		}
		/*public function removeFile(type:String, name:String):void {
			
		}*/
		
		public function addFont(name:String, font:Class):void {
			Font.registerFont(font);
			fontRegistry.setRegister(name, font);
		}
		public function getFont(name:String):Class {
			return fontRegistry.getRegister(name) as Class;
		}
		/*public function removeFont(name:String):void {
			
		}*/
		
		public function addOption(type:String, name:String, value:*):void {
			if (!optionsRegistry.getRegister(type)) {
				optionsRegistry.setRegister(type, new Object());
			}
			
			(optionsRegistry.getRegister(type) as Object)[name] = value;
		}
		public function getOption(type:String, name:String):* {
			if (!optionsRegistry.getRegister(type)) {
				return null;
			}
			
			return (optionsRegistry.getRegister(type) as Object)[name];
		}
		/*public function removeOption(type:String, name:String):void {
			
		}*/
		
		public function addBitmapData(url:String, data:BitmapData):void {
			textureRegistry.setRegister(stripURL(url) + "_bmd", data);
		}
		public function getBitmapData(url:String):BitmapData {
			return textureRegistry.getRegister(stripURL(url) + "_bmd") as BitmapData;
		}
		/*public function removeBitmapData(url:String):void {
			
		}*/
		
		public function addTexture(url:String, texture:Texture):void {
			textureRegistry.setRegister(stripURL(url) + "_tex", texture);
		}
		public function getTexture(url:String):Texture {
			return textureRegistry.getRegister(stripURL(url) + "_tex") as Texture;
		}
		/*public function removeTexture(url:String):void {
			
		}*/
		
		public function addAtlas(url:String, atlas:TextureAtlas):void {
			textureRegistry.setRegister(stripURL(url) + "_atlas", atlas);
		}
		public function getAtlas(url:String):TextureAtlas {
			return textureRegistry.getRegister(stripURL(url) + "_atlas") as TextureAtlas;
		}
		/*public function removeAtlas(url:String):void {
			
		}*/
		
		public function addXML(url:String, xml:XML):void {
			textureRegistry.setRegister(stripURL(url) + "_xml", xml);
		}
		public function getXML(url:String):XML {
			return textureRegistry.getRegister(stripURL(url) + "_xml") as XML;
		}
		/*public function removeXML(url:String):void {
			
		}*/
		
		public function stripURL(url:String):String {
			return url.replace(/\W|_/g, "_");
		}
		
		//private
		
	}
}