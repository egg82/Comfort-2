package egg82.custom {
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import org.as3wavsound.sazameki.core.AudioSamples;
	import org.as3wavsound.sazameki.core.AudioSetting;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class CustomWavSoundPlayer {
		// The size of the master sample buffer used for playback.
		// Too small: the sound will have a jittery playback.
		// Too big: the sound will have high latencies (loading, stopping, playing, etc.). 
		public static var MAX_BUFFERSIZE:Number = 8192;

		// the master samples buffer in which all seperate Wavsounds are mixed into, always stereo at 44100Hz and bitrate 16
		private const sampleBuffer:AudioSamples = new AudioSamples(new AudioSetting(), MAX_BUFFERSIZE);
		// a list of all WavSound currenctly in playing mode
		private const playingWavSounds:Vector.<CustomWavSoundChannel> = new Vector.<CustomWavSoundChannel>();
		
		// the singular playback Sound with which all other WavSounds are played back
		private const player:Sound = configurePlayer();
		
		/**
		 * Static initializer: creates, configures and a sound player using the 'sample 
		 * data event technique'. Until play() has been called on a WavSound, nothing is 
		 * audible, because playingWavSounds will still be empty.
		 * 
		 * Also see: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/SampleDataEvent.html
		 */
		private function configurePlayer():Sound {
			var player:Sound = new Sound();
			player.addEventListener(SampleDataEvent.SAMPLE_DATA, onSamplesCallback);
			player.play();
			return player;
		}
		
		/**
		 * Creates WavSoundChannel and adds it to the list of currently playing channels 
		 * (which are mixed into the master sample buffer).
		 * 
		 * This function is called by WavSound instances which returns the new WavSoundChannel 
		 * instance to the user. 
		 */
		internal function play(sound:CustomWavSound, startTime:Number, loops:int, sndTransform:SoundTransform):CustomWavSoundChannel {
			var channel:CustomWavSoundChannel = new CustomWavSoundChannel(this, sound, startTime, loops, sndTransform);
			playingWavSounds.push(channel);
			return channel;
		}
		
		/**
		 * Remove a specific currently playing channel, so that its samples won't be 
		 * mixed to the master sample buffer anymore and therefor playback will stop.
		 */
		internal function stop(channel:CustomWavSoundChannel):void {
			for each (var playingWavSound:CustomWavSoundChannel in playingWavSounds) {
				if (playingWavSound == channel) {
					playingWavSounds.splice(playingWavSounds.lastIndexOf(playingWavSound), 1);
				}
			}
		}
		
		/**
		 * The heartbeat of the WavSound approach, invoked by the master Sound object.
		 * 
		 * This function handles the SampleDataEvent to mix all playing sounds in playingWavSounds 
		 * into the Sound's buffer. For each playing WavSoundChannel instance, the player will call 
		 * the channel's buffer() function to have it mix itself into the master sample buffer.
		 * Finally, the resulting master buffer is written to the event's output stream.
		 * 
		 * Also see: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/SampleDataEvent.html
		 * 
		 * @param event Contains the soundcard outputstream to mix sound samples into.
		 */
		private function onSamplesCallback(event:SampleDataEvent):void {
			// clear the buffer
			sampleBuffer.clearSamples();
			// have all channels mix their into the master sample buffer
			for each (var playingWavSound:CustomWavSoundChannel in playingWavSounds) {
				//TODO: Fix this
				//playingWavSound.buffer(sampleBuffer);
			}
			
			// extra references to avoid excessive getter calls in the following 
			// for-loop (it appeares CPU is being hogged otherwise)
			var outputStream:ByteArray = event.data;
			var samplesLength:Number = sampleBuffer.length;
			var samplesLeft:Vector.<Number> = sampleBuffer.left;
			var samplesRight:Vector.<Number> = sampleBuffer.right;
			
			// write all mixed samples to the sound's outputstream
			for (var i:int = 0; i < samplesLength; i++) {
				outputStream.writeFloat(samplesLeft[i]);
				outputStream.writeFloat(samplesRight[i]);
			}
		}
	}
}