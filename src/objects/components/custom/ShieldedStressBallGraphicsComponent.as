package objects.components.custom {
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistryUtil;
	import egg82.registry.RegistryUtil;
	import egg82.utils.MathUtil;
	import objects.components.AnimatedGraphicsComponent;
	import objects.components.BlankGraphicsComponent;
	import objects.components.GraphicsComponent;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class ShieldedStressBallGraphicsComponent extends BlankGraphicsComponent {
		//vars
		private var registryUtil:IRegistryUtil = ServiceLocator.getService(ServiceType.REGISTRY_UTIL) as IRegistryUtil;
		
		private var registryUtilObserver:Observer = new Observer();
		
		private var _animations:Boolean;
		
		private var _scale:Number = 1;
		
		private var ball:GraphicsComponent;
		private var sparks:Vector.<AnimatedGraphicsComponent> = new Vector.<AnimatedGraphicsComponent>();
		
		//constructor
		public function ShieldedStressBallGraphicsComponent(gameType:String) {
			ball = new GraphicsComponent(gameType, "ball_shielded", 0.6);
		}
		
		//public
		override public function create():void {
			var i:uint;
			
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			for (i = 0; i < 5; i++) {
				sparks.push(new AnimatedGraphicsComponent("spark", MathUtil.betterRoundedRandom(1, 25)));
			}
			
			ball.create();
			for (i = 0; i < sparks.length; i++) {
				sparks[i].alpha = 0.1;
				sparks[i].rotation = MathUtil.random(0, Math.PI * 2);
				sparks[i].create();
			}
			
			_animations = registryUtil.getOption(OptionsRegistryType.VIDEO, "animations") as Boolean;
			resetAnimations();
		}
		
		override public function destroy():void {
			Observer.remove(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			ball.destroy();
			for (var i:uint = 0; i < sparks.length; i++) {
				sparks[i].destroy();
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
			ball.scale = _scale;
			for (var i:uint = 0; i < sparks.length; i++) {
				sparks[i].scale = _scale;
			}
		}
		
		override public function draw():void {
			if (_animations) {
				for (var i:uint = 0; i < sparks.length; i++) {
					if (sparks[i].frameNum >= 25) {
						sparks[i].frameNum = 1;
					} else {
						sparks[i].frameNum++;
					}
					sparks[i].rotation += MathUtil.random(0.00872665, 0.0174533);
				}
			}
		}
		
		public function resetTexture():void {
			ball.resetTexture();
			for (var i:uint = 0; i < sparks.length; i++) {
				sparks[i].resetTexture();
			}
			
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
			
			removeChildren();
			
			addChild(ball);
			
			if (_animations) {
				for (var i:uint = 0; i < sparks.length; i++) {
					addChild(sparks[i]);
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
	}
}