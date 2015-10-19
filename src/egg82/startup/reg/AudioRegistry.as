package egg82.startup.reg {
	import egg82.registry.Registry;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class AudioRegistry extends Registry {
		//vars
		
		//constructor
		public function AudioRegistry() {
			
		}
		
		//public
		override public function initialize():void {
			setRegister("ambient", [
				//{"name": "", "data": null}
			]);
			setRegister("music", [
				//{"name": "", "data": null}
			]);
			setRegister("sfx", [
				//{"name": "", "data": null}
			]);
			setRegister("ui", [
				//{"name": "", "data": null}
			]);
			setRegister("voice", [
				//{"name": "", "data": null}
			]);
		}
		
		//private
		
	}
}