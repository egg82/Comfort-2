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
	import flash.media.SoundTransform;
	import org.as3wavsound.WavSound;
	import org.as3wavsound.WavSoundChannel;
	//import org.as3wavsound.WavSoundPlayer;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class CustomWavSoundChannel extends WavSoundChannel {
		//vars
		private var _sound:CustomWavSound;
		
		//constructor
		//TODO: Fix all this
		public function CustomWavSoundChannel(player:CustomWavSoundPlayer, wavSound:WavSound, startTime:Number, loops:int, soundTransform:SoundTransform) {
			_sound = wavSound as CustomWavSound;
			//super(player, wavSound, startTime, loops, soundTransform);
			super(null, wavSound, startTime, loops, soundTransform);
		}
		
		//public
		public function get sound():CustomWavSound {
			return _sound;
		}
		
		//private
		
	}
}