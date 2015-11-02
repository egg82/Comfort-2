package objects.components.custom {
	import com.greensock.easing.Circ;
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistryUtil;
	import egg82.registry.RegistryUtil;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import objects.components.AnimatedGraphicsComponent;
	import objects.components.BlankGraphicsComponent;
	import objects.components.GraphicsComponent;
	import objects.components.MaskedGraphicsComponent;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class CoreGraphicsComponent extends BlankGraphicsComponent {
		//vars
		private var registryUtil:IRegistryUtil = ServiceLocator.getService(ServiceType.REGISTRY_UTIL) as IRegistryUtil;
		
		private var registryUtilObserver:Observer = new Observer();
		
		private var _animations:Boolean;
		
		private var radius:Number;
		private var _scale:Number = 1;
		private var _brightness:Number = 0;
		
		private var core:GraphicsComponent;
		private var pulse:BlankGraphicsComponent = new BlankGraphicsComponent();
		
		private var rotatingFluid:AnimatedGraphicsComponent = new AnimatedGraphicsComponent("noise");
		private var movingFluid:AnimatedGraphicsComponent = new AnimatedGraphicsComponent("noise");
		private var masked:MaskedGraphicsComponent = new MaskedGraphicsComponent();
		
		private var pulseTimer:Timer = new Timer(2000);
		
		//constructor
		public function CoreGraphicsComponent(gameType:String, radius:Number) {
			this.radius = radius;
			masked.canvas.drawCircle(0, 0, radius);
			
			core = new GraphicsComponent(gameType, "core", 0.6);
		}
		
		//public
		override public function create():void {
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			rotatingFluid.alpha = 0.1;
			movingFluid.alpha = 0.1;
			
			pulse.graphics.beginFill(0xFFFFFF);
			pulse.graphics.drawCircle(0, 0, radius);
			pulse.graphics.endFill();
			
			pulse.create();
			core.create();
			rotatingFluid.create();
			movingFluid.create();
			masked.create();
			
			_animations = registryUtil.getOption(OptionsRegistryType.VIDEO, "animations") as Boolean;
			resetAnimations();
		}
		override public function destroy():void {
			Observer.remove(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			pulse.destroy();
			core.destroy();
			rotatingFluid.destroy();
			movingFluid.destroy();
			masked.destroy();
			
			if (pulseTimer.running) {
				pulseTimer.stop();
				pulseTimer.removeEventListener(TimerEvent.TIMER, onPulseTimer);
			}
		}
		
		override public function draw():void {
			if (_animations) {
				rotatingFluid.rotation += 0.00872665;
				
				movingFluid.x -= 0.5;
				movingFluid.y -= 0.5;
				
				if (movingFluid.x + movingFluid.width <= core.width) {
					movingFluid.x = 0;
				}
				if (movingFluid.y + movingFluid.height <= core.height) {
					movingFluid.y = 0;
				}
			}
		}
		
		override public function get scale():Number {
			return _scale;
		}
		override public function set scale(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_scale = val;
			core.scale = _scale;
			masked.scale = _scale;
		}
		
		override public function get brightness():Number {
			return _brightness;
		}
		override public function set brightness(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_brightness = val;
			core.brightness = _brightness;
		}
		
		public function resetTexture():void {
			core.resetTexture();
			rotatingFluid.resetTexture();
			movingFluid.resetTexture();
			
			if (isFlattened) {
				unflatten();
			}
			resetAnimations();
		}
		
		//private
		private function resetAnimations():void {
			if (_animations) {
				if (isFlattened) {
					unflatten();
				}
			} else {
				if (!isFlattened) {
					flatten();
				}
			}
			
			masked.removeChildren();
			removeChildren();
			
			if (_animations) {
				addChild(pulse);
			}
			
			addChild(core);
			
			if (_animations) {
				masked.addChild(rotatingFluid);
				masked.addChild(movingFluid);
				
				addChild(masked.canvas);
				addChild(masked);
				
				if (!pulseTimer.running) {
					pulseTimer.addEventListener(TimerEvent.TIMER, onPulseTimer);
					pulseTimer.start();
				}
			} else {
				if (pulseTimer.running) {
					pulseTimer.stop();
					pulseTimer.removeEventListener(TimerEvent.TIMER, onPulseTimer);
				}
			}
		}
		
		private function onRegistryUtilObserverNotify(sender:Object, event:String, data:Object):void {
			if (data.registry == "optionsRegistry") {
				checkOptions(data.type as String, data.name as String, data.value as Object);
			}
		}
		private function checkOptions(type:String, name:String, value:Object):void {
			if (type == OptionsRegistryType.VIDEO && name == "animations") {
				_animations = value as Boolean;
				resetAnimations();
			}
		}
		
		private function onPulseTimer(e:TimerEvent):void {
			TweenMax.to(pulse, 2, {
				"scaleX": 1.75,
				"scaleY": 1.75,
				"ease": Circ.easeOut
			});
			TweenMax.to(pulse, 2, {
				"alpha": 0,
				"ease": Expo.easeOut,
				"onComplete": resetPulse
			});
		}
		private function resetPulse():void {
			pulse.scaleX = pulse.scaleY = 1;
			pulse.alpha = 1;
		}
	}
}