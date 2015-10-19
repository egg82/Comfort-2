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

package egg82.registry.interfaces {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public interface IRegistryUtil {
		//vars
		
		//constructor
		
		//public
		function initialize():void;
		
		function setFile(type:String, name:String, url:String):void;
		function getFile(type:String, name:String):String;
		function setAudio(type:String, name:String, data:ByteArray):void;
		function getAudio(type:String, name:String):ByteArray;
		function setFont(name:String, font:Class):void;
		function getFont(name:String):Class;
		function setOption(type:String, name:String, value:*):void;
		function getOption(type:String, name:String):*;
		function setBitmapData(url:String, data:BitmapData):void;
		function getBitmapData(url:String):BitmapData;
		function setTexture(url:String, texture:Texture):void;
		function getTexture(url:String):Texture;
		function setAtlas(url:String, atlas:TextureAtlas):void;
		function getAtlas(url:String):TextureAtlas;
		function setXML(url:String, xml:XML):void;
		function getXML(url:String):XML;
		
		function stripURL(url:String):String;
		
		//private
		
	}
}