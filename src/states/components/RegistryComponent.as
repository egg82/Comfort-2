package states.components {
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.patterns.interfaces.IComponent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistryUtil;
	import egg82.registry.RegistryUtil;
	import enums.CustomOptionsRegistryType;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class RegistryComponent implements IComponent {
		//vars
		private var registryUtil:IRegistryUtil = ServiceLocator.getService(ServiceType.REGISTRY_UTIL) as IRegistryUtil;
		
		private var registryUtilObserver:Observer = new Observer();
		
		private var _textureQuality:String;
		private var _musicQuality:String;
		private var _ambientQuality:String;
		private var _sfxQuality:String;
		private var _screenShake:Boolean;
		private var _animations:Boolean;
		
		private var _fireKeys:Array;
		private var _fireButtons:Array;
		private var _autoFire:Boolean;
		private var _controllerDeadZone:Number;
		
		private var _gameType:String;
		private var _difficulty:String;
		private var _health:Number;
		private var _nemesisImpulseRate:Number;
		private var _nemesisImpulseChance:Number;
		private var _fireRate:Number;
		private var _minObjects:uint;
		private var _remedySpawnRate:Number;
		private var _remedySpawnChance:Number;
		private var _remedyTime:Number;
		private var _remedyPower:Number;
		private var _reinforceSpawnRate:Number;
		private var _reinforceSpawnChance:Number;
		private var _reinforceTime:Number;
		private var _reinforcePower:Number;
		private var _reliefSpawnRate:Number;
		private var _reliefSpawnChance:Number;
		private var _reliefPower:Number;
		private var _stressSpawnRate:Number;
		private var _stressSpawnChance:Number;
		private var _stressPower:Number;
		private var _shieldedStressSpawnRate:Number;
		private var _shieldedStressSpawnChance:Number;
		private var _shieldedStressPower:Number;
		private var _explosiveStressSpawnRate:Number;
		private var _explosiveStressSpawnChance:Number;
		private var _explosiveStressPower:Number;
		private var _clusterStressNumber:Number;
		private var _clusterStressPower:Number;
		
		//constructor
		public function RegistryComponent(gameType:String) {
			_gameType = gameType;
		}
		
		//public
		public function create():void {
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			_ambientQuality = registryUtil.getOption(OptionsRegistryType.AUDIO, "ambientQuality") as String;
			_musicQuality = registryUtil.getOption(OptionsRegistryType.AUDIO, "musicQuality") as String;
			_sfxQuality = registryUtil.getOption(OptionsRegistryType.AUDIO, "sfxQuality") as String;
			_textureQuality = registryUtil.getOption(OptionsRegistryType.VIDEO, "textureQuality") as String;
			_screenShake = registryUtil.getOption(OptionsRegistryType.VIDEO, "screenShake") as Boolean;
			_animations = registryUtil.getOption(OptionsRegistryType.VIDEO, "animations") as Boolean;
			
			_fireKeys = registryUtil.getOption(OptionsRegistryType.KEYS, "fire") as Array;
			_fireButtons = registryUtil.getOption(OptionsRegistryType.CONTROLLER, "fire") as Array;
			_autoFire = registryUtil.getOption(CustomOptionsRegistryType.GAMEPLAY, "autoFire") as Boolean;
			_controllerDeadZone = registryUtil.getOption(OptionsRegistryType.CONTROLLER, "deadZone") as Number;
			
			_difficulty = registryUtil.getOption(CustomOptionsRegistryType.GAMEPLAY, "difficulty") as String;
			_health = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "health") as Number;
			_nemesisImpulseRate = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "nemesisImpulseRate") as Number;
			_nemesisImpulseChance = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "nemesisImpulseChance") as Number;
			_fireRate = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "fireRate") as Number;
			_minObjects = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "minObjects") as uint;
			_remedySpawnRate = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "remedySpawnRate") as Number;
			_remedySpawnChance = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "remedySpawnChance") as Number;
			_remedyTime = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "remedyTime") as Number;
			_remedyPower = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "remedyPower") as Number;
			_reinforceSpawnRate = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "reinforceSpawnRate") as Number;
			_reinforceSpawnChance = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "reinforceSpawnChance") as Number;
			_reinforceTime = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "reinforceTime") as Number;
			_reinforcePower = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "reinforcePower") as Number;
			_reliefSpawnRate = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "reliefSpawnRate") as Number;
			_reliefSpawnChance = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "reliefSpawnChance") as Number;
			_reliefPower = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "reliefPower") as Number;
			_stressSpawnRate = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "stressSpawnRate") as Number;
			_stressSpawnChance = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "stressSpawnChance") as Number;
			_stressPower = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "stressPower") as Number;
			_shieldedStressSpawnRate = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "shieldedStressSpawnRate") as Number;
			_shieldedStressSpawnChance = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "shieldedStressSpawnChance") as Number;
			_shieldedStressPower = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "shieldedStressPower") as Number;
			_explosiveStressSpawnRate = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "explosiveStressSpawnRate") as Number;
			_explosiveStressSpawnChance = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "explosiveStressSpawnChance") as Number;
			_explosiveStressPower = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "explosiveStressPower") as Number;
			_clusterStressNumber = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "clusterStressNumber") as Number;
			_clusterStressPower = registryUtil.getOption(CustomOptionsRegistryType.SETUP, "clusterStressPower") as Number;
		}
		public function destroy():void {
			Observer.remove(RegistryUtil.OBSERVERS, registryUtilObserver);
		}
		
		public function get ambientQuality():String {
			return _ambientQuality;
		}
		public function get musicQuality():String {
			return _musicQuality;
		}
		public function get sfxQuality():String {
			return _sfxQuality;
		}
		public function get textureQuality():String {
			return _textureQuality;
		}
		public function get screenShake():Boolean {
			return _screenShake;
		}
		public function get animations():Boolean {
			return _animations;
		}
		
		public function get fireKeys():Array {
			return _fireKeys;
		}
		public function get fireButtons():Array {
			return _fireButtons;
		}
		public function get autoFire():Boolean {
			return _autoFire;
		}
		public function get controllerDeadZone():Number {
			return _controllerDeadZone;
		}
		
		public function get gameType():String {
			return _gameType;
		}
		public function get difficulty():String {
			return _difficulty;
		}
		public function get health():Number {
			return _health;
		}
		public function get nemesisImpulseRate():Number {
			return _nemesisImpulseRate;
		}
		public function get nemesisImpulseChance():Number {
			return _nemesisImpulseChance;
		}
		public function get fireRate():Number {
			return _fireRate;
		}
		public function get minObjects():uint {
			return _minObjects;
		}
		public function get remedySpawnRate():Number {
			return _remedySpawnRate;
		}
		public function get remedySpawnChance():Number {
			return _remedySpawnChance;
		}
		public function get remedyTime():Number {
			return _remedyTime;
		}
		public function get remedyPower():Number {
			return _remedyPower;
		}
		public function get reinforceSpawnRate():Number {
			return _reinforceSpawnRate;
		}
		public function get reinforceSpawnChance():Number {
			return _reinforceSpawnChance;
		}
		public function get reinforceTime():Number {
			return _reinforceTime;
		}
		public function get reinforcePower():Number {
			return _reinforcePower;
		}
		public function get reliefSpawnRate():Number {
			return _reliefSpawnRate;
		}
		public function get reliefSpawnChance():Number {
			return _reliefSpawnChance;
		}
		public function get reliefPower():Number {
			return _reliefPower;
		}
		public function get stressSpawnRate():Number {
			return _stressSpawnRate;
		}
		public function get stressSpawnChance():Number {
			return _stressSpawnChance;
		}
		public function get stressPower():Number {
			return _stressPower;
		}
		public function get shieldedStressSpawnRate():Number {
			return _shieldedStressSpawnRate;
		}
		public function get shieldedStressSpawnChance():Number {
			return _shieldedStressSpawnChance;
		}
		public function get shieldedStressPower():Number {
			return _shieldedStressPower;
		}
		public function get explosiveStressSpawnRate():Number {
			return _explosiveStressSpawnRate;
		}
		public function get explosiveStressSpawnChance():Number {
			return _explosiveStressSpawnChance;
		}
		public function get explosiveStressPower():Number {
			return _explosiveStressPower;
		}
		public function get clusterStressNumber():Number {
			return _clusterStressNumber;
		}
		public function get clusterStressPower():Number {
			return _clusterStressPower;
		}
		
		//private
		private function onRegistryUtilObserverNotify(sender:Object, event:String, data:Object):void {
			if (data.registry == "optionsRegistry") {
				checkOptions(data.type as String, data.name as String, data.value as Object);
			}
		}
		private function checkOptions(type:String, name:String, value:Object):void {
			if (type == OptionsRegistryType.VIDEO && name == "textureQuality") {
				_textureQuality = value as String;
			} else if (type == OptionsRegistryType.AUDIO && name == "musicQuality") {
				_musicQuality = value as String;
			} else if (type == OptionsRegistryType.AUDIO && name == "ambientQuality") {
				_ambientQuality = value as String;
			} else if (type == OptionsRegistryType.AUDIO && name == "sfxQuality") {
				_sfxQuality = value as String;
			} else if (type == OptionsRegistryType.VIDEO && name == "screenShake") {
				_screenShake = value as Boolean;
			} else if (type == OptionsRegistryType.VIDEO && name == "animations") {
				_animations = value as Boolean;
			}
			
			if (type == CustomOptionsRegistryType.GAMEPLAY && name == "autoFire") {
				_autoFire = value as String;
			} else if (type == OptionsRegistryType.KEYS && name == "fire") {
				_fireKeys = value as Array;
			} else if (type == OptionsRegistryType.CONTROLLER && name == "fire") {
				_fireButtons = value as Array;
			} else if (type == OptionsRegistryType.CONTROLLER && name == "deadZone") {
				_controllerDeadZone = value as Number;
			}
			
			if (type == CustomOptionsRegistryType.GAMEPLAY && name == "difficulty") {
				_difficulty = value as String;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "health") {
				_health = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "nemesisImpulseRate") {
				_nemesisImpulseRate = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "nemesisImpulseChance") {
				_nemesisImpulseChance = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "fireRate") {
				_fireRate = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "minObjects") {
				_minObjects = value as uint;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "remedySpawnRate") {
				_remedySpawnRate = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "remedySpawnChance") {
				_remedySpawnChance = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "remedyTime") {
				_remedyTime = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "remedyPower") {
				_remedyPower = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "reinforceSpawnRate") {
				_reinforceSpawnRate = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "reinforceSpawnChance") {
				_reinforceSpawnChance = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "reinforceTime") {
				_reinforceTime = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "reinforcePower") {
				_reinforcePower = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "reliefSpawnRate") {
				_reliefSpawnRate = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "reliefSpawnChance") {
				_reliefSpawnChance = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "reliefPower") {
				_reliefPower = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "stressSpawnRate") {
				_stressSpawnRate = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "stressSpawnChance") {
				_stressSpawnChance = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "stressPower") {
				_stressPower = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "shieldedStressSpawnRate") {
				_shieldedStressSpawnRate = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "shieldedStressSpawnChance") {
				_shieldedStressSpawnChance = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "shieldedStressPower") {
				_shieldedStressPower = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "explosiveStressSpawnRate") {
				_explosiveStressSpawnRate = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "explosiveStressSpawnChance") {
				_explosiveStressSpawnChance = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "explosiveStressPower") {
				_explosiveStressPower = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "clusterStressNumber") {
				_clusterStressNumber = value as Number;
			} else if (type == CustomOptionsRegistryType.SETUP && name == "clusterStressPower") {
				_clusterStressPower = value as Number;
			}
		}
	}
}