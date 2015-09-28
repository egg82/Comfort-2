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

package egg82.engines.loggers {
	import egg82.custom.CustomSound;
	import egg82.custom.CustomWavSound;
	import egg82.engines.SoundEngine;
	import egg82.enums.LogLevel;
	import egg82.log.interfaces.ILogger;
	import egg82.patterns.ServiceLocator;
	import egg82.utils.Util;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class LoggingSoundEngine extends SoundEngine {
		//vars
		private var logger:ILogger = ServiceLocator.getService("logger") as ILogger;
		
		//constructor
		public function LoggingSoundEngine() {
			
		}
		
		//public
		override public function initialize():void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Initialized", LogLevel.INFO);
			super.initialize();
		}
		
		override public function playWav(data:ByteArray, name:String, repeat:Boolean = false, volume:Number = 1):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([data, name, repeat, volume]), LogLevel.INFO);
			super.playWav(data, name, repeat, volume);
		}
		override public function playMp3(data:ByteArray, name:String, repeat:Boolean = false, volume:Number = 1):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([data, name, repeat, volume]), LogLevel.INFO);
			super.playMp3(data, name, repeat, volume);
		}
		
		override public function stopWav(name:String):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([name]), LogLevel.INFO);
			super.stopWav(name);
		}
		override public function stopMp3(name:String):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([name]), LogLevel.INFO);
			super.stopMp3(name);
		}
		
		override public function getWav(name:String):CustomWavSound {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([name]), LogLevel.INFO);
			return super.getWav(name);
		}
		override public function getMp3(name:String):CustomSound {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([name]), LogLevel.INFO);
			return super.getMp3(name);
		}
		
		override public function getWavName(index:uint):String {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([index]), LogLevel.INFO);
			return super.getWavName(index);
		}
		override public function getMp3Name(index:uint):String {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([index]), LogLevel.INFO);
			return super.getMp3Name(index);
		}
		
		override public function setWavVolume(name:String, volume:Number = 1):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([name, volume]), LogLevel.INFO);
			super.setWavVolume(name, volume);
		}
		override public function setMp3Volume(name:String, volume:Number = 1):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([name, volume]), LogLevel.INFO);
			super.setMp3Volume(name, volume);
		}
		
		//private
		override protected function dispatch(event:String, data:Object = null):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Dispatched event \"" + event + "\" with data " + JSON.stringify(data), LogLevel.INFO);
			super.dispatch(event, data);
		}
	}
}