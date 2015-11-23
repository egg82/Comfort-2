package util {
	import egg82.utils.MathUtil;
	import flash.utils.getTimer;
	import starling.display.DisplayObject;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class Shake {
		//vars
		private var duration:Number;
		private var frequency:uint;
		private var amplitude:uint;
		
		private var samplesX:Vector.<Number>;
		private var samplesY:Vector.<Number>;
		private var samplesRotation:Vector.<Number>;
		
		private var startTime:int;
		private var t:int;
		private var _isShaking:Boolean;
		
		private var object:DisplayObject;
		private var origX:Number;
		private var origY:Number;
		private var origRotation:Number;
		
		//constructor
		public function Shake(duration:Number, frequency:uint, amplitude:uint) {
			if (isNaN(duration) || duration <= 0) {
				throw new Error("duration must be > 0");
			}
			if (isNaN(frequency) || frequency == 0) {
				throw new Error("frequency must be > 0");
			}
			if (isNaN(amplitude) ||amplitude == 0) {
				throw new Error("amplitude must be > 0");
			}
			
			this.duration = duration * 1000;
			this.frequency = frequency;
			this.amplitude = amplitude;
			
			startTime = 0;
			t = 0;
			_isShaking = false;
		}
		
		//public
		public function get shaking():Boolean {
			return _isShaking;
		}
		
		public function start(object:DisplayObject):void {
			if (_isShaking || !object) {
				return;
			}
			this.object = object;
			
			origX = object.x;
			origY = object.y;
			origRotation = object.rotation;
			
			var sampleCount:uint = Math.floor(duration * frequency);
			
			samplesX = new Vector.<Number>();
			samplesY = new Vector.<Number>();
			samplesRotation = new Vector.<Number>();
			for (var i:uint = 0; i < sampleCount; i++) {
				samplesX[i] = MathUtil.random(-1, 1);
				samplesY[i] = MathUtil.random(-1, 1);
				samplesRotation[i] = MathUtil.random(-1, 1);
			}
			
			t = startTime = getTimer();
			_isShaking = true;
		}
		
		public function update():void {
			t = getTimer() - startTime;
			if (t > duration) {
				object.x = origX;
				object.y = origY;
				object.rotation = origRotation;
				
				_isShaking = false;
			} else {
				object.x = origX + getAmplitudeX(t);
				object.y = origY + getAmplitudeY(t);
				object.rotation = origRotation + (getAmplitudeRotation(t) * Math.PI / 180);
			}
		}
		
		public function getAmplitudeX(t:int = NaN):Number {
			if (isNaN(t) || t < 0) {
				if (!_isShaking) {
					return 0;
				}
				t = this.t;
			}
			
			var s:Number = t / 1000 * frequency;
			var s0:int = Math.floor(s);
			var s1:int = s0 + 1;
			
			var k:Number = decay(t);
			
			return ((noiseX(s0) + (s - s0) * (noiseX(s1) - noiseX(s0))) * k) * amplitude;
		}
		public function getAmplitudeY(t:int = NaN):Number {
			if (isNaN(t) || t < 0) {
				if (!_isShaking) {
					return 0;
				}
				t = this.t;
			}
			
			var s:Number = t / 1000 * frequency;
			var s0:int = Math.floor(s);
			var s1:int = s0 + 1;
			
			var k:Number = decay(t);
			
			return ((noiseY(s0) + (s - s0) * (noiseY(s1) - noiseY(s0))) * k) * amplitude;
		}
		
		public function getAmplitudeRotation(t:int = NaN):Number {
			if (isNaN(t) || t < 0) {
				if (!_isShaking) {
					return 0;
				}
				t = this.t;
			}
			
			var s:Number = t / 1000 * frequency;
			var s0:int = Math.floor(s);
			var s1:int = s0 + 1;
			
			var k:Number = decay(t);
			
			return ((noiseRotation(s0) + (s - s0) * (noiseRotation(s1) - noiseRotation(s0))) * k) * amplitude;
		}
		
		//private
		private function noiseX(s:int):Number {
			return (s < samplesX.length) ? samplesX[s] : 0;
		}
		private function noiseY(s:int):Number {
			return (s < samplesY.length) ? samplesY[s] : 0;
		}
		private function noiseRotation(s:int):Number {
			return (s < samplesRotation.length) ? samplesRotation[s] : 0;
		}
		
		private function decay(t:int):Number {
			return (t < duration) ? (duration - t) / duration : 0;
			//return (t < duration) ? 1 * (0.5) ^ t : 0;
		}
	}
}