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

package egg82.engines {
	import egg82.custom.CustomSound;
	import egg82.custom.CustomWavSound;
	import egg82.engines.interfaces.ISoundEngine;
	import egg82.events.engines.SoundEngineEvent;
	import egg82.patterns.Observer;
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import org.as3wavsound.WavSoundChannel;
	
	//TODO: Make SoundEngine download sounds only when it needs them - as an option
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class SoundEngine implements ISoundEngine {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var playingMp3s:Vector.<SoundChannel> = new Vector.<SoundChannel>();
		private var playingMp3Sounds:Vector.<CustomSound> = new Vector.<CustomSound>();
		private var playingMp3Names:Vector.<String> = new Vector.<String>();
		
		private var playingWavs:Vector.<WavSoundChannel> = new Vector.<WavSoundChannel>();
		private var playingWavSounds:Vector.<CustomWavSound> = new Vector.<CustomWavSound>();
		private var playingWavNames:Vector.<String> = new Vector.<String>();
		
		//constructor
		public function SoundEngine() {
			
		}
		
		//public
		public function initialize():void {
			dispatch(SoundEngineEvent.INITIALIZE);
		}
		
		public function playWav(data:ByteArray, name:String, repeat:Boolean = false, volume:Number = 1):void {
			if (!data || data.length == 0 || playingWavNames.indexOf(name) > -1) {
				return;
			}
			
			if (volume > 1) {
				volume = 1;
			}
			if (volume < 0) {
				volume = 0;
			}
			
			var sound:CustomWavSound = new CustomWavSound(data, repeat);
			var channel:WavSoundChannel = sound.play(0, 0, new SoundTransform(volume));
			
			channel.addEventListener(Event.SOUND_COMPLETE, onWavComplete);
			
			playingWavSounds.push(sound);
			playingWavs.push(channel);
			playingWavNames.push(name);
		}
		public function playMp3(data:ByteArray, name:String, repeat:Boolean = false, volume:Number = 1):void {
			if (!data || data.length == 0 || playingMp3Names.indexOf(name) > -1) {
				return;
			}
			
			if (volume > 1) {
				volume = 1;
			}
			if (volume < 0) {
				volume = 0;
			}
			
			var sound:CustomSound = new CustomSound(repeat);
			var channel:SoundChannel;
			
			sound.loadCompressedDataFromByteArray(data, data.length);
			channel = sound.play(0, 0, new SoundTransform(volume));
			channel.addEventListener(Event.SOUND_COMPLETE, onMp3Complete);
			
			playingMp3Sounds.push(sound);
			playingMp3s.push(channel);
			playingMp3Names.push(name);
		}
		
		public function stopWav(name:String):void {
			var index:int = playingWavNames.indexOf(name);
			
			if (index == -1) {
				return;
			}
			
			playingWavs[index].stop();
			playingWavs[index].removeEventListener(Event.SOUND_COMPLETE, onWavComplete);
			
			playingWavSounds.splice(index, 1);
			playingWavs.splice(index, 1);
			playingWavNames.splice(index, 1);
		}
		public function stopMp3(name:String):void {
			var index:int = playingMp3Names.indexOf(name);
			
			if (index == -1) {
				return;
			}
			
			playingMp3s[index].stop();
			playingMp3s[index].removeEventListener(Event.SOUND_COMPLETE, onMp3Complete);
			
			playingMp3Sounds.splice(index, 1);
			playingMp3s.splice(index, 1);
			playingMp3Names.splice(index, 1);
		}
		
		public function getWav(name:String):CustomWavSound {
			var index:int = playingWavNames.indexOf(name);
			
			if (index == -1) {
				return null;
			}
			
			return playingWavSounds[index];
		}
		public function getMp3(name:String):CustomSound {
			var index:int = playingMp3Names.indexOf(name);
			
			if (index == -1) {
				return null;
			}
			
			return playingMp3Sounds[index];
		}
		
		public function get numPlayingWavs():uint {
			return playingWavs.length;
		}
		public function get numPlayingMp3s():uint {
			return playingMp3s.length;
		}
		
		public function getWavName(index:uint):String {
			if (index >= playingWavNames.length) {
				return null;
			}
			
			return playingWavNames[index];
		}
		public function getMp3Name(index:uint):String {
			if (index >= playingMp3Names.length) {
				return null;
			}
			
			return playingMp3Names[index];
		}
		
		public function setWavVolume(name:String, volume:Number = 1):void {
			var index:int = playingWavNames.indexOf(name);
			
			if (index == -1) {
				return;
			}
			
			if (volume > 1) {
				volume = 1;
			}
			if (volume < 0) {
				volume = 0;
			}
			
			//TODO: Get wav files to SoundTransform on-the-fly like MP3s.
			//playingWavs[index].soundTransform = new SoundTransform(volume);
		}
		public function setMp3Volume(name:String, volume:Number = 1):void {
			var index:int = playingMp3Names.indexOf(name);
			
			if (index == -1) {
				return;
			}
			
			if (volume > 1) {
				volume = 1;
			}
			if (volume < 0) {
				volume = 0;
			}
			
			playingMp3s[index].soundTransform = new SoundTransform(volume);
		}
		
		//private
		private function onMp3Complete(e:Event):void {
			var channel:SoundChannel = e.target as SoundChannel;
			var sound:CustomSound;
			var soundIndex:uint;
			
			for (var i:uint = 0; i < playingMp3s.length; i++) {
				if (channel === playingMp3s[i]) {
					soundIndex = i;
					break;
				}
			}
			
			sound = playingMp3Sounds[soundIndex];
			
			channel.removeEventListener(Event.SOUND_COMPLETE, onMp3Complete);
			
			if (sound.repeat) {
				dispatch(SoundEngineEvent.MP3_COMPLETE);
				playingMp3s[soundIndex] = sound.play();
				playingMp3s[soundIndex].addEventListener(Event.SOUND_COMPLETE, onMp3Complete);
			} else {
				playingMp3Sounds.splice(soundIndex, 1);
				playingMp3s.splice(soundIndex, 1);
				dispatch(SoundEngineEvent.MP3_COMPLETE);
			}
		}
		private function onWavComplete(e:Event):void {
			var channel:WavSoundChannel = e.target as WavSoundChannel;
			var sound:CustomWavSound;
			var soundIndex:uint;
			
			for (var i:uint = 0; i < playingWavs.length; i++) {
				if (channel === playingWavs[i]) {
					soundIndex = i;
					break;
				}
			}
			
			sound = playingWavSounds[soundIndex];
			
			channel.removeEventListener(Event.SOUND_COMPLETE, onWavComplete);
			
			if (sound.repeat) {
				dispatch(SoundEngineEvent.WAV_COMPLETE);
				playingWavs[soundIndex] = sound.play();
				playingWavs[soundIndex].addEventListener(Event.SOUND_COMPLETE, onWavComplete);
			} else {
				playingWavSounds.splice(soundIndex, 1);
				playingWavs.splice(soundIndex, 1);
				dispatch(SoundEngineEvent.WAV_COMPLETE);
			}
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}