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

package egg82.engines.interfaces {
	import egg82.custom.CustomSound;
	import egg82.custom.CustomWavSound;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public interface ISoundEngine {
		//vars
		
		//constructor
		
		//public
		function initialize():void;
		
		function playWav(data:ByteArray, name:String, repeat:Boolean = false, volume:Number = 1):void;
		function playMp3(data:ByteArray, name:String, repeat:Boolean = false, volume:Number = 1):void;
		
		function stopWav(name:String):void;
		function stopMp3(name:String):void;
		
		function getWav(name:String):CustomWavSound;
		function getMp3(name:String):CustomSound;
		
		function get numPlayingWavs():uint;
		function get numPlayingMp3s():uint;
		
		function getWavName(index:uint):String;
		function getMp3Name(index:uint):String;
		
		function setWavVolume(name:String, volume:Number = 1):void;
		function setMp3Volume(name:String, volume:Number = 1):void;
		
		//private
		
	}
}