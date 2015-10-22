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
		
		private var _fireKeys:Array;
		private var _fireButtons:Array;
		private var _autoFire:Boolean;
		private var _controllerDeadZone:Number;
		
		//constructor
		public function RegistryComponent() {
			
		}
		
		//public
		public function create():void {
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			_ambientQuality = registryUtil.getOption(OptionsRegistryType.AUDIO, "ambientQuality") as String;
			_musicQuality = registryUtil.getOption(OptionsRegistryType.AUDIO, "musicQuality") as String;
			_sfxQuality = registryUtil.getOption(OptionsRegistryType.AUDIO, "sfxQuality") as String;
			_textureQuality = registryUtil.getOption(OptionsRegistryType.VIDEO, "textureQuality") as String;
			
			_fireKeys = registryUtil.getOption(OptionsRegistryType.KEYS, "fire") as Array;
			_fireButtons = registryUtil.getOption(OptionsRegistryType.CONTROLLER, "fire") as Array;
			_autoFire = registryUtil.getOption(CustomOptionsRegistryType.GAMEPLAY, "autoFire") as Boolean;
			_controllerDeadZone = registryUtil.getOption(OptionsRegistryType.CONTROLLER, "deadZone") as Number;
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
		
		public function get fireKeys():Array {
			return _fireKeys;
		}
		public function get fireButons():Array {
			return _fireButtons;
		}
		public function get autoFire():Boolean {
			return _autoFire;
		}
		public function get controllerDeadZone():Number {
			return _controllerDeadZone;
		}
		
		//private
		private function onRegistryUtilObserverNotify(sender:Object, event:String, data:Object):void {
			if (data.registry == "optionsRegistry") {
				checkOptions(data.type as String, data.name as String, data.value as Object);
			}
		}
		private function checkOptions(type:String, name:String, value:Object):void {
			if (type == CustomOptionsRegistryType.GAMEPLAY && name == "autoFire") {
				_autoFire = value as String;
			} else if (type == OptionsRegistryType.KEYS && name == "fire") {
				_fireKeys = value as Array;
			} else if (type == OptionsRegistryType.CONTROLLER && name == "fire") {
				_fireButtons = value as Array;
			} else if (type == OptionsRegistryType.CONTROLLER && name == "deadZone") {
				_controllerDeadZone = value as Number;
			}
		}
	}
}